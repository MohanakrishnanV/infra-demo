data "aws_vpc" "prod_vpc" {
  id = var.prod_vpc_id
}

data "aws_db_subnet_group" "prod_db_subnet_group" {
  name = var.prod_db_subnet_group_name
}

resource "aws_db_instance" "csf_prod_db" {
  identifier                            = var.csf_prod_db_name
  engine                                = var.csf_prod_db_engine
  engine_version                        = var.csf_prod_db_engine_version
  instance_class                        = var.csf_prod_db_instance_class
  storage_type                          = var.csf_prod_db_storage_type
  allocated_storage                     = var.csf_prod_db_allocated_storage
  max_allocated_storage                 = var.csf_prod_db_max_allocated_storage
  multi_az                              = var.csf_prod_db_multi_az_flag
  username                              = var.csf_prod_db_admin_username
  password                              = var.csf_prod_db_admin_password
  db_subnet_group_name                  = data.aws_db_subnet_group.prod_db_subnet_group.name
  vpc_security_group_ids                = var.csf_prod_db_securitygroup_ids
  backup_retention_period               = var.csf_prod_db_backup_retention_period
  backup_window                         = var.csf_prod_db_backup_window
  maintenance_window                    = var.csf_prod_db_maintenance_window
  performance_insights_enabled          = var.csf_prod_db_performance_insights_enabled_flag
  performance_insights_retention_period = var.csf_prod_db_performance_insights_retention_period
  skip_final_snapshot                   = var.csf_prod_db_final_snapshot_flag
  final_snapshot_identifier             = var.csf_prod_db_final_snapshot_identifier
  publicly_accessible                   = var.csf_prod_db_public_access_flag
  deletion_protection                   = var.csf_prod_db_delete_protection_flag
  tags = {
    Name = var.csf_prod_db_tag_name
  }
}
