resource "aws_db_subnet_group" "dev_rds_subnet_group" {
  name       = "dev-rds-subnet-group"
  subnet_ids = [aws_subnet.dev_vpc_db_subnet1.id, aws_subnet.dev_vpc_db_subnet2.id]

  tags = {
    Name = "dev-rds-subnet-group"
  }
  depends_on = [aws_subnet.dev_vpc_db_subnet1, aws_subnet.dev_vpc_db_subnet2]
}

resource "aws_security_group" "dev_rds_sg" {
  name        = var.dev_vpc_sg_db_name
  description = "Allow PostgreSQL access from peer VPC"
  vpc_id      = aws_vpc.dev_vpc.id

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
    Name = var.dev_vpc_sg_db_name
  }
  depends_on = [aws_vpc.dev_vpc]
}
