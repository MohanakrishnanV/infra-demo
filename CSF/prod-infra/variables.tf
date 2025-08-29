variable "csf_prod_vm_ami" {
  description = "AMI id of CSF prod vm"
  type        = string
}

variable "csf_prod_vm_instance_type" {
  description = "Instance type for CSF prod vm"
  type        = string
}

variable "csf_prod_vm_key_name" {
  description = "Name of keypair for CSF prod vm"
  type        = string
}

variable "csf_prod_vm_securitygroup_ids" {
  description = "security group ids for CSF prod vm"
  type        = list(string)
}

variable "csf_prod_vm_subnet_id" {
  description = "subnet id for CSF prod vm"
  type        = string
}

variable "csf_prod_vm_api_termination" {
  description = "boolean flag to enable/disable deletion of instance through api"
  type        = bool
}

variable "csf_prod_vm_os_disk_size" {
  description = "CSF prod vm os disk size in GB"
  type        = number
}

variable "csf_prod_vm_os_disk_type" {
  description = "CSF prod vm os disk type"
  type        = string
}

variable "csf_prod_vm_os_disk_termination" {
  description = "bool flag to delete disk when instance terminates"
  type        = bool
}

variable "csf_prod_vm_name" {
  description = "name for CSF prod vm"
  type        = string
}

variable "prod_vpc_id" {
  description = "prod vpc id"
  type        = string
}

variable "prod_db_subnet_group_name" {
  description = "name of db subnet group for prod"
  type        = string
}

variable "csf_prod_db_name" {
  description = "CSF prod db name"
  type        = string
}

variable "csf_prod_db_engine" {
  description = "The database engine to use"
  type        = string
}

variable "csf_prod_db_engine_version" {
  description = "The engine version to use"
  type        = string
}

variable "csf_prod_db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "csf_prod_db_storage_type" {
  description = "The storage type of the RDS instance"
  type        = string
}

variable "csf_prod_db_allocated_storage" {
  description = "The allocated storage in gibibytes"
  type        = number
}

variable "csf_prod_db_max_allocated_storage" {
  description = "Specifies the maximum storage (in GiB) that Amazon RDS can automatically scale to for this DB instance"
  type        = number
}

variable "csf_prod_db_multi_az_flag" {
  description = "bool flag to specify if the RDS instance is multi-AZ"
  type        = bool
}

variable "csf_prod_db_admin_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "csf_prod_db_admin_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "csf_prod_db_securitygroup_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
}

variable "csf_prod_db_backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
}

variable "csf_prod_db_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created"
  type        = string
}

variable "csf_prod_db_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
}

variable "csf_prod_db_performance_insights_enabled_flag" {
  description = "bool flag to specify whether Performance Insights are enabled"
  type        = bool
}

variable "csf_prod_db_performance_insights_retention_period" {
  description = "Amount of time in days to retain Performance Insights data. Valid values are 7, 731 (2 years) or a multiple of 31"
  type        = number
}

variable "csf_prod_db_final_snapshot_flag" {
  description = "bool flag to determine whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
}

variable "csf_prod_db_final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB instance is deleted"
  type        = string
}

variable "csf_prod_db_public_access_flag" {
  description = "bool flag to control if instance is publicly accessible"
  type        = bool
}

variable "csf_prod_db_delete_protection_flag" {
  description = "bool flag for the DB instance to have deletion protection enabled"
  type        = bool
}

variable "csf_prod_db_tag_name" {
  description = "tag with key as Name"
  type        = string
}

variable "vm_ssh_pub_key_paths" {
  description = "paths to ssh pub keys"
  type        = list(string)
}

variable "csf_prod_vm_username" {
  description = "username of csf prod vm admin"
  type        = string
}

variable "csf_prod_vm_private_key_path" {
  description = "local path to private key of admin user for csf prod vm"
  type        = string
}

variable "jenkins_pub_key_path" {
  description = "path to jenkins user pub key"
  type        = string
}

variable "enable_repo_clone" {
  description = "this flag is used to enable or disable repo clone block"
  type        = bool
}

variable "csf_prod_vm_lb_tg_name" {
  description = "target group name of csf prod vm"
  type        = string
}

variable "prod_lb_listn_arn" {
  description = "arn of prod load balancer"
  type        = string
}

variable "csf_prod_domain" {
  description = "domain of csf prod"
  type        = string
}

variable "csf_prod_lb_listn_rule_name" {
  description = "rule name for https listener for csf prod"
  type        = string
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
