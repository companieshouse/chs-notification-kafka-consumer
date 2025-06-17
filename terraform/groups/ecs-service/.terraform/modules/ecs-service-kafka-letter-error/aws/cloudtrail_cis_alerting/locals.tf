locals {
    cis_topic_slack_endpoint = var.cis_topic_slack_endpoint != "" ? var.cis_topic_slack_endpoint : data.vault_generic_secret.security_alerting.data["cis-topic-slack-endpoint"]
}
