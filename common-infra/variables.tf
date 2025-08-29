variable "uat_vpc_cidr" {
  description = "CIDR block for uat vpc"
  type        = string
}

variable "uat_vpc_name" {
  description = "Name of uat vpc"
  type        = string
}

variable "uat_vpc_private_subnet1_cidr" {
  description = "CIDR block for private subnet 1"
  type        = string
}

variable "uat_vpc_private_subnet1_name" {
  description = "Name of uat vpc private subnet 1"
  type        = string
}

variable "uat_vpc_private_subnet2_cidr" {
  description = "CIDR block for private subnet 2"
  type        = string
}

variable "uat_vpc_private_subnet2_name" {
  description = "Name of uat vpc private subnet 2"
  type        = string
}

variable "uat_vpc_public_subnet1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "uat_vpc_public_subnet1_name" {
  description = "Name of uat vpc public subnet 1"
  type        = string
}

variable "uat_vpc_public_subnet2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
}

variable "uat_vpc_public_subnet2_name" {
  description = "Name of uat vpc public subnet 2"
  type        = string
}

variable "uat_vpc_igw_name" {
  description = "Name of internet gateway for uat vpc"
  type        = string
}

variable "uat_nat_eip_name" {
  description = "Name of public ip address for NAT"
  type        = string
}

variable "uat_vpc_nat_name" {
  description = "Name of NAT gateway for uat vpc"
  type        = string
}

variable "uat_vpc_public_rt_name" {
  description = "Name of Route table for public subnets"
  type        = string
}

variable "uat_vpc_private_rt_name" {
  description = "Name of Route table for private subnets"
  type        = string
}

variable "uat_vpc_peer_accepter_account_id" {
  description = "AWS account id of target peer VPC"
  type        = string
}

variable "uat_vpc_peer_accepter_vpc_id" {
  description = "ID of target VPC"
  type        = string
}

variable "uat_vpc_peer_req_conn_name" {
  description = "Name of peering connection for VPC for req account"
  type        = string
}

variable "uat_vpc_peer_accept_conn_name" {
  description = "Name of peering connection for VPC for acceptor account"
  type        = string
}

variable "mgmt_vpc_cidr" {
  description = "CIDR block of mgmt VPC"
  type        = string
}

variable "mgmt_vpc_private_rt_id" {
  description = "Route table id of private subnet of mgmt VPC"
  type        = string
}

variable "mgmt_vpc_public_rt_id" {
  description = "Route table id of public subnet of mgmt VPC"
  type        = string
}

variable "uat_keypair_name" {
  description = "Name of keypair for uat vms"
  type        = string
}

variable "info_bucket_name" {
  description = "Name of s3 bucket for info"
  type        = string
}

variable "uat_vpc_sg_web_name" {
  description = "Name of security group for web acess for uat"
  type        = string
}

variable "uat_vpc_sg_public_name" {
  description = "Name of security group for public access for uat"
  type        = string
}

variable "uat_vpc_db_subnet1_cidr" {
  description = "CIDR block for db subnet 1"
  type        = string
}

variable "uat_vpc_db_subnet1_name" {
  description = "Name of uat vpc db subnet 1"
  type        = string
}

variable "uat_vpc_db_subnet2_cidr" {
  description = "CIDR block for db subnet 2"
  type        = string
}

variable "uat_vpc_db_subnet2_name" {
  description = "Name of uat vpc db subnet 2"
  type        = string
}

variable "uat_vpc_sg_db_name" {
  description = "Name of security group for db access for uat"
  type        = string
}

variable "uat_vm_lb_name" {
  description = "name for load balancer of uat vm"
  type        = string
}

variable "sp_cert_priv_key_path" {
  description = "path to sunpower wildcard cert private key"
  type        = string
}

variable "sp_cert_path" {
  description = "path to sunpower wilcard cert"
  type        = string
}

variable "sp_cert_chain_path" {
  description = "path to sunpower wildcard chain"
  type        = string
}

variable "sp_cert_name" {
  description = "cert name for sunpower wildcard"
  type        = string
}

variable "open_cidr" {
  description = "open to internet"
  type        = string
}

variable "dev_vpc_cidr" {
  description = "CIDR block for dev vpc"
  type        = string
}

variable "dev_vpc_name" {
  description = "Name of dev vpc"
  type        = string
}

variable "dev_vpc_private_subnet1_cidr" {
  description = "CIDR block for private subnet 1"
  type        = string
}

variable "dev_vpc_private_subnet1_name" {
  description = "Name of dev vpc private subnet 1"
  type        = string
}

variable "dev_vpc_private_subnet2_cidr" {
  description = "CIDR block for private subnet 2"
  type        = string
}

variable "dev_vpc_private_subnet2_name" {
  description = "Name of dev vpc private subnet 2"
  type        = string
}

variable "dev_vpc_public_subnet1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "dev_vpc_public_subnet1_name" {
  description = "Name of dev vpc public subnet 1"
  type        = string
}

variable "dev_vpc_public_subnet2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
}

variable "dev_vpc_public_subnet2_name" {
  description = "Name of dev vpc public subnet 2"
  type        = string
}

variable "dev_vpc_igw_name" {
  description = "Name of internet gateway for dev vpc"
  type        = string
}

variable "dev_nat_eip_name" {
  description = "Name of public ip address for NAT"
  type        = string
}

variable "dev_vpc_nat_name" {
  description = "Name of NAT gateway for dev vpc"
  type        = string
}

variable "dev_vpc_public_rt_name" {
  description = "Name of Route table for public subnets"
  type        = string
}

variable "dev_vpc_private_rt_name" {
  description = "Name of Route table for private subnets"
  type        = string
}

variable "dev_vpc_peer_accepter_account_id" {
  description = "AWS account id of target peer VPC"
  type        = string
}

variable "dev_vpc_peer_accepter_vpc_id" {
  description = "ID of target VPC"
  type        = string
}

variable "dev_vpc_peer_req_conn_name" {
  description = "Name of peering connection for VPC for req account"
  type        = string
}

variable "dev_vpc_peer_accept_conn_name" {
  description = "Name of peering connection for VPC for acceptor account"
  type        = string
}

variable "dev_vpc_db_subnet1_cidr" {
  description = "CIDR block for db subnet 1"
  type        = string
}

variable "dev_vpc_db_subnet1_name" {
  description = "Name of dev vpc db subnet 1"
  type        = string
}

variable "dev_vpc_db_subnet2_cidr" {
  description = "CIDR block for db subnet 2"
  type        = string
}

variable "dev_vpc_db_subnet2_name" {
  description = "Name of dev vpc db subnet 2"
  type        = string
}

variable "dev_vpc_sg_db_name" {
  description = "Name of security group for db access for dev"
  type        = string
}

variable "dev_keypair_name" {
  description = "Name of keypair for dev vms"
  type        = string
}

variable "dev_vpc_sg_web_name" {
  description = "Name of security group for web acess for dev"
  type        = string
}

variable "dev_vpc_sg_public_name" {
  description = "Name of security group for public access for dev"
  type        = string
}

variable "dev_vm_lb_name" {
  description = "name for load balancer of dev vm"
  type        = string
}
