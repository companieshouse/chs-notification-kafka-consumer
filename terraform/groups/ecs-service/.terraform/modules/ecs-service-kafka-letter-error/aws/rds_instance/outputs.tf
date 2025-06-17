output "rds_arn" {
  value = aws_db_instance.rds.arn
}

output "rds_availability_zone" {
  value = aws_db_instance.rds.availability_zone
}

output "rds_db_name" {
  value = aws_db_instance.rds.db_name
}

output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "rds_engine" {
  value = aws_db_instance.rds.engine
}

output "rds_engine_version" {
  value = "${aws_db_instance.rds.engine}-${aws_db_instance.rds.engine_version_actual}"
}

output "rds_identifier" {
  value = local.rds_identifier
}

output "rds_security_group_name" {
  value = aws_security_group.rds.name
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}
