resource "aws_db_instance" "csf_uat_rds" {
  identifier                            = var.csf_uat_rds_name
  engine                                = "postgres"
  engine_version                        = var.csf_uat_rds_engine_version
  instance_class                        = var.csf_uat_rds_instance_class
  storage_type                          = "gp3"
  allocated_storage                     = var.csf_uat_rds_allocated_storage
  max_allocated_storage                 = var.csf_uat_rds_max_allocated_storage
  multi_az                              = true
  username                              = var.csf_uat_rds_username
  password                              = var.csf_uat_rds_password
  db_subnet_group_name                  = var.uat_rds_subnetgroup_name
  vpc_security_group_ids                = var.uat_rds_securitygroupids
  backup_retention_period               = var.csf_uat_rds_backup_retentionperiod
  backup_window                         = var.csf_uat_rds_backupwindow
  maintenance_window                    = var.csf_uat_rds_maintenancewindow
  performance_insights_enabled          = true
  performance_insights_retention_period = var.csf_uat_rds_performanceinsights_retentionperiod
  skip_final_snapshot                   = true
  publicly_accessible                   = false
  deletion_protection                   = true
  tags = {
    Name = "csf-uat-postgres"
  }
}
