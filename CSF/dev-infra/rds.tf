resource "aws_db_instance" "csf_dev_rds" {
  identifier                            = var.csf_dev_rds_name
  engine                                = "postgres"
  engine_version                        = var.csf_dev_rds_engine_version
  instance_class                        = var.csf_dev_rds_instance_class
  storage_type                          = "gp3"
  allocated_storage                     = var.csf_dev_rds_allocated_storage
  max_allocated_storage                 = var.csf_dev_rds_max_allocated_storage
  multi_az                              = true
  username                              = var.csf_dev_rds_username
  password                              = var.csf_dev_rds_password
  db_subnet_group_name                  = var.dev_rds_subnetgroup_name
  vpc_security_group_ids                = var.dev_rds_securitygroupids
  backup_retention_period               = var.csf_dev_rds_backup_retentionperiod
  backup_window                         = var.csf_dev_rds_backupwindow
  maintenance_window                    = var.csf_dev_rds_maintenancewindow
  performance_insights_enabled          = true
  performance_insights_retention_period = var.csf_dev_rds_performanceinsights_retentionperiod
  skip_final_snapshot                   = true
  publicly_accessible                   = false
  deletion_protection                   = true
  tags = {
    Name = "csf-dev-postgres"
  }
}