resource "aws_key_pair" "uat_keypair" {
  key_name   = var.uat_keypair_name
  public_key = file("./keys/sp-uat-key.pub")
}

resource "aws_security_group" "uat_vpc_sg_web" {
  name        = var.uat_vpc_sg_web_name
  description = "enable http & https inbound ports access"
  vpc_id      = aws_vpc.uat_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.open_cidr]
    description = "http"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.open_cidr]
    description = "https"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound"
  }
  tags = {
    Name = var.uat_vpc_sg_web_name
  }
}

resource "aws_security_group" "uat_vpc_sg_public" {
  name        = var.uat_vpc_sg_public_name
  description = "ssh & vpn inbound access"
  vpc_id      = aws_vpc.uat_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.mgmt_vpc_cidr]
    description = "ssh"
  }
  ingress {
    from_port   = 51835
    to_port     = 51835
    protocol    = "udp"
    cidr_blocks = [var.mgmt_vpc_cidr]
    description = "udp vpn port"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound"
  }
  tags = {
    Name = var.uat_vpc_sg_public_name
  }
}

resource "aws_lb" "uat_vm_lb" {
  name                       = var.uat_vm_lb_name
  internal                   = false
  load_balancer_type         = "application"
  ip_address_type            = "ipv4"
  security_groups            = [aws_security_group.uat_vpc_sg_web.id]
  subnets                    = [aws_subnet.uat_vpc_public_subnet1.id, aws_subnet.uat_vpc_public_subnet2.id]
  enable_deletion_protection = true
  idle_timeout               = 1200
  tags = {
    Environment = "uat"
  }
}

resource "aws_lb_listener" "uat_vm_lb_http_listn" {
  load_balancer_arn = aws_lb.uat_vm_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_acm_certificate" "sp_wild_import_cert" {
  private_key       = file(var.sp_cert_priv_key_path)
  certificate_body  = file(var.sp_cert_path)
  certificate_chain = file(var.sp_cert_chain_path)
  tags = {
    Name = var.sp_cert_name
  }
}

resource "aws_lb_listener" "uat_vm_lb_https_listn" {
  load_balancer_arn = aws_lb.uat_vm_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = aws_acm_certificate.sp_wild_import_cert.arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}
