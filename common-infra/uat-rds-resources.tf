resource "aws_db_subnet_group" "goals_rds_subnet_group" {
  name       = "uat-rds-subnet-group"
  subnet_ids = [aws_subnet.uat_vpc_db_subnet1.id, aws_subnet.uat_vpc_db_subnet2.id]

  tags = {
    Name = "uat-rds-subnet-group"
  }
}

resource "aws_security_group" "uat_rds_sg" {
  name        = var.uat_vpc_sg_db_name
  description = "Allow PostgreSQL access from peer VPC"
  vpc_id      = aws_vpc.uat_vpc.id

  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.open_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = var.uat_vpc_sg_db_name
  }
}
