variable "uat_vm_ami" {
  description = "AMI id of csf uat vm"
  type        = string
}

variable "uat_vm_instance_type" {
  description = "Instance type for uat vm"
  type        = string
}

variable "uat_vm_keyname" {
  description = "Name of keypair for uat vm"
  type        = string
}

variable "uat_security_group_ids" {
  description = "security group ids for uat"
  type        = list(string)
}

variable "uat_vm_subnet_id" {
  description = "subnet id for uat vm"
  type        = string
}

variable "uat_vm_os_disk_size" {
  description = "uat vm os disk size in GB"
  type        = number
}

variable "uat_vm_name" {
  description = "name for uat vm"
  type        = string
}

variable "csf_uat_rds_name" {
  description = "Name of rds for csf UAT"
  type        = string
}

variable "csf_uat_rds_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
}

variable "csf_uat_rds_instance_class" {
  description = "Instance type for RDS"
  type        = string
}

variable "csf_uat_rds_allocated_storage" {
  description = "Initial storage in GiB"
  type        = number
}

variable "csf_uat_rds_max_allocated_storage" {
  description = "Max autoscaling storage in GiB"
  type        = number
}

variable "csf_uat_rds_username" {
  description = "Master username"
  type        = string
  sensitive   = true
}

variable "csf_uat_rds_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "uat_rds_subnetgroup_name" {
  description = "subnet group name of uat rds"
  type        = string
}

variable "uat_rds_securitygroupids" {
  description = "security group ids for uat rds"
  type        = list(string)
}

variable "csf_uat_rds_backup_retentionperiod" {
  description = "Days to retain backup"
  type        = number
}

variable "csf_uat_rds_backupwindow" {
  description = "timerange in utc"
  type        = string
}

variable "csf_uat_rds_maintenancewindow" {
  description = "window to perform maintenance"
  type        = string
}

variable "csf_uat_rds_performanceinsights_retentionperiod" {
  description = "Days to retain performance insights"
  type        = number
}

variable "csf_uat_vm_username" {
  description = "username of admin for uat vm"
  type        = string
}

variable "csf_uat_vm_private_key_path" {
  description = "local path to private key file for vm"
  type        = string
}

variable "vm_ssh_pub_key_paths" {
  description = "paths to ssh pub keys"
  type        = list(string)
}

variable "jenkins_pub_key_path" {
  description = "path to jenkins user pub key"
  type        = string
}

variable "csf_uat_vm_lb_tg_name" {
  description = "target group name of csf uat vm"
  type        = string
}

variable "uat_vpc_id" {
  description = "id of uat vpc"
  type        = string
}

variable "uat_lb_listn_arn" {
  description = "arn of uat load balancer"
  type        = string
}

variable "csf_uat_domain" {
  description = "domain of csf uat"
  type        = string
}

variable "csf_uat_lb_listn_rule_name" {
  description = "rule name for https listener for csf uat"
  type        = string
}

variable "enable_repo_clone" {
  description = "this flag is used to enable or disable repo clone block"
  type        = bool
}

variable "aws_access_key_id" {
  description = "aws access key id to configure for jenkins user to be able to download env files from s3"
  type        = string
}

variable "aws_secret_access_key" {
  description = "aws secret access key to configure for jenkins user to be able to download env files from s3"
  type        = string
}

variable "aws_region" {
  description = "aws region for jenkins user configuration"
  type        = string
}
