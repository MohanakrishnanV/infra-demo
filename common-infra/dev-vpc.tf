resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.dev_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.dev_vpc_name
  }
}

resource "aws_subnet" "dev_vpc_private_subnet1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.dev_vpc_private_subnet1_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"
  tags = {
    Name = var.dev_vpc_private_subnet1_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_subnet" "dev_vpc_private_subnet2" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.dev_vpc_private_subnet2_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2d"
  tags = {
    Name = var.dev_vpc_private_subnet2_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_subnet" "dev_vpc_public_subnet1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.dev_vpc_public_subnet1_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"
  tags = {
    Name = var.dev_vpc_public_subnet1_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_subnet" "dev_vpc_public_subnet2" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.dev_vpc_public_subnet2_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2d"
  tags = {
    Name = var.dev_vpc_public_subnet2_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_internet_gateway" "dev_vpc_igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = var.dev_vpc_igw_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_eip" "dev_nat_eip" {
  domain = "vpc"
  tags = {
    Name = var.dev_nat_eip_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_nat_gateway" "dev_vpc_nat" {
  allocation_id = aws_eip.dev_nat_eip.id
  subnet_id     = aws_subnet.dev_vpc_public_subnet1.id
  tags = {
    Name = var.dev_vpc_nat_name
  }
  depends_on = [aws_vpc.dev_vpc, aws_eip.dev_nat_eip, aws_subnet.dev_vpc_public_subnet1]
}

resource "aws_route_table" "dev_vpc_public_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = var.dev_vpc_public_rt_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_route" "dev_vpc_public_rt_default_route" {
  route_table_id         = aws_route_table.dev_vpc_public_rt.id
  destination_cidr_block = var.open_cidr
  gateway_id             = aws_internet_gateway.dev_vpc_igw.id
  depends_on             = [aws_route_table.dev_vpc_public_rt, aws_internet_gateway.dev_vpc_igw]
}

resource "aws_route_table_association" "dev_vpc_public_rt_assoc1" {
  subnet_id      = aws_subnet.dev_vpc_public_subnet1.id
  route_table_id = aws_route_table.dev_vpc_public_rt.id
  depends_on     = [aws_subnet.dev_vpc_public_subnet1, aws_route_table.dev_vpc_public_rt]
}

resource "aws_route_table_association" "dev_vpc_public_rt_assoc2" {
  subnet_id      = aws_subnet.dev_vpc_public_subnet2.id
  route_table_id = aws_route_table.dev_vpc_public_rt.id
  depends_on     = [aws_subnet.dev_vpc_public_subnet2, aws_route_table.dev_vpc_public_rt]
}

resource "aws_route_table" "dev_vpc_private_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = var.dev_vpc_private_rt_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_route" "dev_vpc_private_rt_default_route" {
  route_table_id         = aws_route_table.dev_vpc_private_rt.id
  destination_cidr_block = var.open_cidr
  nat_gateway_id         = aws_nat_gateway.dev_vpc_nat.id
  depends_on             = [aws_route_table.dev_vpc_private_rt, aws_nat_gateway.dev_vpc_nat]
}

resource "aws_route_table_association" "dev_vpc_private_rt_assoc1" {
  subnet_id      = aws_subnet.dev_vpc_private_subnet1.id
  route_table_id = aws_route_table.dev_vpc_private_rt.id
  depends_on     = [aws_subnet.dev_vpc_private_subnet1, aws_route_table.dev_vpc_private_rt]
}

resource "aws_route_table_association" "dev_vpc_private_rt_assoc2" {
  subnet_id      = aws_subnet.dev_vpc_private_subnet2.id
  route_table_id = aws_route_table.dev_vpc_private_rt.id
  depends_on     = [aws_subnet.dev_vpc_private_subnet2, aws_route_table.dev_vpc_private_rt]
}

resource "aws_vpc_peering_connection" "dev_vpc_peer_req" {
  peer_owner_id = var.dev_vpc_peer_accepter_account_id
  vpc_id        = aws_vpc.dev_vpc.id
  peer_vpc_id   = var.dev_vpc_peer_accepter_vpc_id
  auto_accept   = false
  tags = {
    Name = var.dev_vpc_peer_req_conn_name
    Side = "Requester"
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_vpc_peering_connection_accepter" "dev_vpc_peer_accept" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.dev_vpc_peer_req.id
  auto_accept               = true
  tags = {
    Name = var.dev_vpc_peer_accept_conn_name
    Side = "Accepter"
  }
  depends_on = [aws_vpc_peering_connection.dev_vpc_peer_req]
}

resource "aws_route" "dev_vpc_private_to_mgmt_route" {
  route_table_id            = aws_route_table.dev_vpc_private_rt.id
  destination_cidr_block    = var.mgmt_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.dev_vpc_peer_req.id
  depends_on                = [aws_route_table.dev_vpc_private_rt, aws_vpc_peering_connection.dev_vpc_peer_req]
}

resource "aws_route" "dev_vpc_public_to_mgmt_route" {
  route_table_id            = aws_route_table.dev_vpc_public_rt.id
  destination_cidr_block    = var.mgmt_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.dev_vpc_peer_req.id
  depends_on                = [aws_route_table.dev_vpc_public_rt, aws_vpc_peering_connection.dev_vpc_peer_req]
}

resource "aws_route" "mgmt_vpc_private_to_sp_dev_route" {
  provider                  = aws.accepter
  route_table_id            = var.mgmt_vpc_private_rt_id
  destination_cidr_block    = var.dev_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.dev_vpc_peer_accept.id
  depends_on                = [aws_vpc_peering_connection_accepter.dev_vpc_peer_accept]
}

resource "aws_route" "mgmt_vpc_public_to_sp_dev_route" {
  provider                  = aws.accepter
  route_table_id            = var.mgmt_vpc_public_rt_id
  destination_cidr_block    = var.dev_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.dev_vpc_peer_accept.id
  depends_on                = [aws_vpc_peering_connection_accepter.dev_vpc_peer_accept]
}

resource "aws_subnet" "dev_vpc_db_subnet1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.dev_vpc_db_subnet1_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"
  tags = {
    Name = var.dev_vpc_db_subnet1_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_subnet" "dev_vpc_db_subnet2" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.dev_vpc_db_subnet2_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2d"
  tags = {
    Name = var.dev_vpc_db_subnet2_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_route_table_association" "dev_vpc_db_rt_assoc1" {
  subnet_id      = aws_subnet.dev_vpc_db_subnet1.id
  route_table_id = aws_route_table.dev_vpc_private_rt.id
  depends_on     = [aws_subnet.dev_vpc_db_subnet1, aws_route_table.dev_vpc_private_rt]
}

resource "aws_route_table_association" "dev_vpc_db_rt_assoc2" {
  subnet_id      = aws_subnet.dev_vpc_db_subnet2.id
  route_table_id = aws_route_table.dev_vpc_private_rt.id
  depends_on     = [aws_subnet.dev_vpc_db_subnet2, aws_route_table.dev_vpc_private_rt]
}
