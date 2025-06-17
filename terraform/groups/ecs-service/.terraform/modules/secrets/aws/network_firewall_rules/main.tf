provider "aws" {
  region = "eu-west-2"
}

locals {
  # For each rules directory, get a list of rules files
  csv_stateless_rule_groups = toset(distinct(compact(flatten([ for directory in var.csv_stateless_rule_files_directories : fileset("", "${directory}/*.csv") ]))))
  csv_domain_rule_groups = toset(distinct(compact(flatten([ for directory in var.csv_domain_rule_files_directories : fileset("", "${directory}/*.csv") ]))))
}

resource "aws_networkfirewall_rule_group" "csv_stateless_rule_groups" {
  for_each = local.csv_stateless_rule_groups

  name        = split("_", basename(each.value))[1]                #extract the second portion of the file name and use this as the name
  capacity    = split(".", split("_", basename(each.value))[2])[0] #extract the 3rd part of the file name, remove the extention and use this as the capacity

  tags        = merge(var.tags, {"priority" = split("_", basename(each.value))[0]})
  
  type        = "STATELESS"
  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        dynamic "stateless_rule" {
          for_each = csvdecode(file(each.value))
          content {
            priority = stateless_rule.value.priority
            rule_definition {
              actions = formatlist("aws:%s", [ for action in split(";", stateless_rule.value.actions) : trimspace(action)])
              match_attributes {

                dynamic "source" {
                  for_each = split(";", stateless_rule.value.sources)
                  content {
                    address_definition = trimspace(source.value)
                  }
                }

                dynamic "source_port" {
                  for_each = split(";", stateless_rule.value.sourceports)
                  content {
                    from_port = can(regex("-", source_port.value)) ? split("-", source_port.value)[0] : source_port.value
                    to_port = can(regex("-", source_port.value)) ? split("-", source_port.value)[1] : source_port.value
                  }
                }

                dynamic "destination" {
                  for_each = split(";", stateless_rule.value.destinations)
                  content {
                    address_definition = trimspace(destination.value)
                  }
                }

                dynamic "destination_port" {
                  for_each = split(";", stateless_rule.value.destinationports)
                  content {
                    from_port = can(regex("-", destination_port.value)) ? split("-", destination_port.value)[0] : destination_port.value
                    to_port = can(regex("-", destination_port.value)) ? split("-", destination_port.value)[1] : destination_port.value
                  }
                }

                protocols = stateless_rule.value.protocols != "" ? split(";", stateless_rule.value.protocols) : null

                dynamic "tcp_flag" {
                  for_each = stateless_rule.value.tcpflags != "" || stateless_rule.value.tcpmasks != "" ? [1] : []
                  content {
                    flags = stateless_rule.value.tcpflags == "" ? null : split(";", stateless_rule.value.tcpflags)
                    masks = stateless_rule.value.tcpmasks == "" ? null : split(";", stateless_rule.value.tcpmasks)
                  }
                }
              }
            }
          } 
        }  
      }
    }
  }
}


resource "aws_networkfirewall_rule_group" "csv_domain_rule_groups" {
  for_each = local.csv_domain_rule_groups

  name        = split("_", basename(each.value))[2]                #extract the first portion of the file name and use this as the name
  capacity    = split(".", split("_", basename(each.value))[3])[0] #extract the second part of the file name, remove the extention and use this as the capacity

  tags        = merge(var.tags, {"priority" = split("_", basename(each.value))[0]})

  type     = "STATEFUL"
  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = upper(split("_", basename(each.value))[1]) == "ALLOW" ? "ALLOWLIST" : upper(split("_", basename(each.value))[0]) == "DENY" ? "DENYLIST" : null
        target_types         = ["HTTP_HOST", "TLS_SNI"]
        targets              = [ for line in csvdecode(file(each.value)) : line.domain ]
      }
    }
  }
}
