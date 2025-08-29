resource "aws_key_pair" "dev_keypair" {
  key_name   = var.dev_keypair_name
  public_key = file("./keys/sp-dev-key.pub")
}

resource "aws_security_group" "dev_vpc_sg_web" {
  name        = var.dev_vpc_sg_web_name
  description = "enable http & https inbound ports access"
  vpc_id      = aws_vpc.dev_vpc.id
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
    Name = var.dev_vpc_sg_web_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_security_group" "dev_vpc_sg_public" {
  name        = var.dev_vpc_sg_public_name
  description = "ssh & vpn inbound access"
  vpc_id      = aws_vpc.dev_vpc.id
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
    Name = var.dev_vpc_sg_public_name
  }
  depends_on = [aws_vpc.dev_vpc]
}

resource "aws_lb" "dev_vm_lb" {
  name                       = var.dev_vm_lb_name
  internal                   = false
  load_balancer_type         = "application"
  ip_address_type            = "ipv4"
  security_groups            = [aws_security_group.dev_vpc_sg_web.id]
  subnets                    = [aws_subnet.dev_vpc_public_subnet1.id, aws_subnet.dev_vpc_public_subnet2.id]
  enable_deletion_protection = true
  idle_timeout               = 1200
  tags = {
    Environment = "dev"
  }
  depends_on = [aws_security_group.dev_vpc_sg_web, aws_subnet.dev_vpc_public_subnet1, aws_subnet.dev_vpc_public_subnet2]
}

resource "aws_lb_listener" "dev_vm_lb_http_listn" {
  load_balancer_arn = aws_lb.dev_vm_lb.arn
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
  depends_on = [aws_lb.dev_vm_lb]
}

resource "aws_lb_listener" "dev_vm_lb_https_listn" {
  load_balancer_arn = aws_lb.dev_vm_lb.arn
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
  depends_on = [aws_lb.dev_vm_lb, aws_acm_certificate.sp_wild_import_cert]
}
