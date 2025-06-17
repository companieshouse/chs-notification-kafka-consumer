resource "aws_security_group" "zookeeper" {
  description = "Restricts access for ${var.service}-${var.environment} zookeeper nodes"
  name = "${var.service}-${var.environment}-zookeeper"
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
    description     = "Cluster Manager for Apache Kafka (CMAK)"
    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
    security_groups = [
      aws_security_group.cmak_load_balancer.id
    ]
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
    description     = "Zookeeper client access"
    from_port       = var.zookeeper_client_port
    to_port         = var.zookeeper_client_port
    protocol        = "tcp"
    cidr_blocks     = var.zookeeper_client_access.cidr_blocks
    prefix_list_ids = var.zookeeper_client_access.list_ids
  }

  ingress {
    description     = "Zookeeper peer access"
    from_port       = var.zookeeper_peer_port
    to_port         = var.zookeeper_election_port
    protocol        = "tcp"
    cidr_blocks     = var.zookeeper_peer_access.cidr_blocks
    prefix_list_ids = var.zookeeper_peer_access.list_ids
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-${var.environment}-zookeeper"
    Environment = var.environment
    Service     = var.service
    Type        = "SecurityGroup"
  }
}

resource "aws_security_group" "cmak_load_balancer" {
  description = "Restricts access to the cmak load balancer"
  name = "${var.service}-${var.environment}-cmak-load-balancer"
  vpc_id = var.vpc_id

  ingress {
    description     = "Cluster Manager for Apache Kafka"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = var.cmak_access.cidr_blocks
    prefix_list_ids = var.cmak_access.list_ids
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-${var.environment}-cmak"
    Environment = var.environment
    Service     = var.service
    Type        = "SecurityGroup"
  }
}
