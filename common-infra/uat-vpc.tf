resource "aws_vpc" "uat_vpc" {
  cidr_block           = var.uat_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.uat_vpc_name
  }
}

resource "aws_subnet" "uat_vpc_private_subnet1" {
  vpc_id                  = aws_vpc.uat_vpc.id
  cidr_block              = var.uat_vpc_private_subnet1_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"
  tags = {
    Name = var.uat_vpc_private_subnet1_name
  }
}

resource "aws_subnet" "uat_vpc_private_subnet2" {
  vpc_id                  = aws_vpc.uat_vpc.id
  cidr_block              = var.uat_vpc_private_subnet2_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2d"
  tags = {
    Name = var.uat_vpc_private_subnet2_name
  }
}

resource "aws_subnet" "uat_vpc_public_subnet1" {
  vpc_id                  = aws_vpc.uat_vpc.id
  cidr_block              = var.uat_vpc_public_subnet1_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"
  tags = {
    Name = var.uat_vpc_public_subnet1_name
  }
}

resource "aws_subnet" "uat_vpc_public_subnet2" {
  vpc_id                  = aws_vpc.uat_vpc.id
  cidr_block              = var.uat_vpc_public_subnet2_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2d"
  tags = {
    Name = var.uat_vpc_public_subnet2_name
  }
}

resource "aws_internet_gateway" "uat_vpc_igw" {
  vpc_id = aws_vpc.uat_vpc.id
  tags = {
    Name = var.uat_vpc_igw_name
  }
}

resource "aws_eip" "uat_nat_eip" {
  domain = "vpc"
  tags = {
    Name = var.uat_nat_eip_name
  }
}

resource "aws_nat_gateway" "uat_vpc_nat" {
  allocation_id = aws_eip.uat_nat_eip.id
  subnet_id     = aws_subnet.uat_vpc_public_subnet1.id
  tags = {
    Name = var.uat_vpc_nat_name
  }
}

resource "aws_route_table" "uat_vpc_public_rt" {
  vpc_id = aws_vpc.uat_vpc.id
  tags = {
    Name = var.uat_vpc_public_rt_name
  }
}

resource "aws_route" "uat_vpc_public_rt_default_route" {
  route_table_id         = aws_route_table.uat_vpc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.uat_vpc_igw.id
}

resource "aws_route_table_association" "uat_vpc_public_rt_assoc1" {
  subnet_id      = aws_subnet.uat_vpc_public_subnet1.id
  route_table_id = aws_route_table.uat_vpc_public_rt.id
}

resource "aws_route_table_association" "uat_vpc_public_rt_assoc2" {
  subnet_id      = aws_subnet.uat_vpc_public_subnet2.id
  route_table_id = aws_route_table.uat_vpc_public_rt.id
}

resource "aws_route_table" "uat_vpc_private_rt" {
  vpc_id = aws_vpc.uat_vpc.id
  tags = {
    Name = var.uat_vpc_private_rt_name
  }
}

resource "aws_route" "uat_vpc_private_rt_default_route" {
  route_table_id         = aws_route_table.uat_vpc_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.uat_vpc_nat.id
}

resource "aws_route_table_association" "uat_vpc_private_rt_assoc1" {
  subnet_id      = aws_subnet.uat_vpc_private_subnet1.id
  route_table_id = aws_route_table.uat_vpc_private_rt.id
}

resource "aws_route_table_association" "uat_vpc_private_rt_assoc2" {
  subnet_id      = aws_subnet.uat_vpc_private_subnet2.id
  route_table_id = aws_route_table.uat_vpc_private_rt.id
}

resource "aws_vpc_peering_connection" "uat_vpc_peer_req" {
  peer_owner_id = var.uat_vpc_peer_accepter_account_id
  vpc_id        = aws_vpc.uat_vpc.id
  peer_vpc_id   = var.uat_vpc_peer_accepter_vpc_id
  auto_accept   = false
  tags = {
    Name = var.uat_vpc_peer_req_conn_name
    Side = "Requester"
  }
}

resource "aws_vpc_peering_connection_accepter" "uat_vpc_peer_accept" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.uat_vpc_peer_req.id
  auto_accept               = true
  tags = {
    Name = var.uat_vpc_peer_accept_conn_name
    Side = "Accepter"
  }
}

resource "aws_route" "uat_vpc_private_to_mgmt_route" {
  route_table_id            = aws_route_table.uat_vpc_private_rt.id
  destination_cidr_block    = var.mgmt_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.uat_vpc_peer_req.id
}

resource "aws_route" "uat_vpc_public_to_mgmt_route" {
  route_table_id            = aws_route_table.uat_vpc_public_rt.id
  destination_cidr_block    = var.mgmt_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.uat_vpc_peer_req.id
}

resource "aws_route" "mgmt_vpc_private_to_sp_uat_route" {
  provider                  = aws.accepter
  route_table_id            = var.mgmt_vpc_private_rt_id
  destination_cidr_block    = var.uat_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.uat_vpc_peer_accept.id
}

resource "aws_route" "mgmt_vpc_public_to_sp_uat_route" {
  provider                  = aws.accepter
  route_table_id            = var.mgmt_vpc_public_rt_id
  destination_cidr_block    = var.uat_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.uat_vpc_peer_accept.id
}

resource "aws_subnet" "uat_vpc_db_subnet1" {
  vpc_id                  = aws_vpc.uat_vpc.id
  cidr_block              = var.uat_vpc_db_subnet1_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"
  tags = {
    Name = var.uat_vpc_db_subnet1_name
  }
}

resource "aws_subnet" "uat_vpc_db_subnet2" {
  vpc_id                  = aws_vpc.uat_vpc.id
  cidr_block              = var.uat_vpc_db_subnet2_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2d"
  tags = {
    Name = var.uat_vpc_db_subnet2_name
  }
}

resource "aws_route_table_association" "uat_vpc_db_rt_assoc1" {
  subnet_id      = aws_subnet.uat_vpc_db_subnet1.id
  route_table_id = aws_route_table.uat_vpc_private_rt.id
}

resource "aws_route_table_association" "uat_vpc_db_rt_assoc2" {
  subnet_id      = aws_subnet.uat_vpc_db_subnet2.id
  route_table_id = aws_route_table.uat_vpc_private_rt.id
}
