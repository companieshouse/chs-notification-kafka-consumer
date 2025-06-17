module "infrastructure_tags" {
  source = "git@github.com:companieshouse/terraform-modules//aws/infrastructure-tags?ref=tags/1.0.295"

  repository = var.repository
  team       = var.team
}
