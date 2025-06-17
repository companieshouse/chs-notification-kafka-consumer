output "efs_access_points" {
  description = "Returns all attributes for the EFS access point resources"
  value       = aws_efs_access_point.efs
}

output "efs_access_point_arns" {
  description = "Returns the arns for the EFS access point resources"
  value       = {
    for key, ap in aws_efs_access_point.efs : key => {
      arn = ap.arn
    }
  }
}

output "efs_access_point_ids" {
  description = "Returns the ids for the EFS access point resources"
  value       = {
    for key, ap in aws_efs_access_point.efs : key => {
      id = ap.id
    }
  }
}

output "efs_filesystem_arn" {
  description = "Returns the arn attribute of the EFS resource"
  value       = aws_efs_file_system.efs.arn
}

output "efs_filesystem_id" {
  description = "Returns the id attribute of the EFS resource"
  value       = aws_efs_file_system.efs.id
}

output "efs_filesystem_dns_name" {
  description = "Returns the dns_name attribute of the EFS resource"
  value       = aws_efs_file_system.efs.dns_name
}

output "efs_mount_targets" {
  description = "Returns all attributes for the EFS mount target resource"
  value       = aws_efs_mount_target.efs
}

output "efs_mount_target_dns_names" {
  description = "Returns the AZ-specific mount_target_dns_names for the EFS mount target resources"
  value       = {
    for key, mt in aws_efs_mount_target.efs : key => {
      mount_target_dns_name = mt.mount_target_dns_name
    }
  }
}

output "efs_mount_target_ids" {
  description = "Returns the ids for the EFS mount target resources"
  value       = {
    for key, mt in aws_efs_mount_target.efs : key => {
      id = mt.id
    }
  }
}

output "efs_mount_target_ip_addresses" {
  description = "Returns the ip addresses for the EFS mount target resources"
  value       = {
    for key, mt in aws_efs_mount_target.efs : key => {
      ip_address = mt.ip_address
    }
  }
}

output "efs_security_group_id" {
  description = "Returns the id of the mount target security group resource"
  value       = aws_security_group.efs.id
}
