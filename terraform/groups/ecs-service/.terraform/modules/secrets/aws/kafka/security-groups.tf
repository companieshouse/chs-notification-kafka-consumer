resource "aws_security_group" "kafka" {
  description = "Restricts access for ${var.service}-${var.environment} kafka nodes"
  name = "${var.service}-${var.environment}-kafka"
  vpc_id = var.vpc_id

  ingress {
    description     = "Inbound SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = var.ssh_access.cidr_blocks
    prefix_list_ids = var.ssh_access.list_ids
  }

  ingress {
    description     = "Kafka"
    from_port       = var.kafka_port
    to_port         = var.kafka_port
    protocol        = "tcp"
    cidr_blocks     = var.kafka_broker_access.cidr_blocks
    prefix_list_ids = var.kafka_broker_access.list_ids
  }

  ingress {
    description     = "Prometheus"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    cidr_blocks     = var.prometheus_access.cidr_blocks
    prefix_list_ids = var.prometheus_access.list_ids
  }

  ingress {
    description     = "Prometheus Kafka Exporter"
    from_port       = 9308
    to_port         = 9308
    protocol        = "tcp"
    cidr_blocks     = var.prometheus_access.cidr_blocks
    prefix_list_ids = var.prometheus_access.list_ids
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-${var.environment}-kafka"
    Environment = var.environment
    Service     = var.service
    Type        = "SecurityGroup"
  }
}
