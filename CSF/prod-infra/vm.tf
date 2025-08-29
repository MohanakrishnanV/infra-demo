resource "aws_instance" "csf_prod_vm" {
  ami                     = var.csf_prod_vm_ami
  instance_type           = var.csf_prod_vm_instance_type
  key_name                = var.csf_prod_vm_key_name
  vpc_security_group_ids  = var.csf_prod_vm_securitygroup_ids
  subnet_id               = var.csf_prod_vm_subnet_id
  disable_api_termination = var.csf_prod_vm_api_termination
  root_block_device {
    volume_size           = var.csf_prod_vm_os_disk_size
    volume_type           = var.csf_prod_vm_os_disk_type
    delete_on_termination = var.csf_prod_vm_os_disk_termination
  }
  tags = {
    Name = var.csf_prod_vm_name
  }
}

resource "terraform_data" "setup_authorized_keys" {
  provisioner "file" {
    content     = join("\n", [for path in var.vm_ssh_pub_key_paths : file(path)])
    destination = "/tmp/authorized_keys"

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ubuntu/.ssh",
      "sudo touch /home/ubuntu/.ssh/authorized_keys",
      "sudo chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "sudo cat /tmp/authorized_keys | sudo tee -a /home/ubuntu/.ssh/authorized_keys > /dev/null",
      "sudo sort -u /home/ubuntu/.ssh/authorized_keys -o /home/ubuntu/.ssh/authorized_keys",
      "sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  triggers_replace = {
    keys_hash = join("-", [for path in var.vm_ssh_pub_key_paths : filesha256(path)])
  }

  depends_on = [aws_instance.csf_prod_vm]
}

resource "terraform_data" "jenkins_user" {
  provisioner "file" {
    source      = var.jenkins_pub_key_path
    destination = "/tmp/jenkins.pub"

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "if ! id -u jenkins &>/dev/null; then sudo useradd -m -d /home/jenkins -s /bin/bash jenkins || (echo 'useradd failed' && exit 1); fi",
      "sudo grep -q '^jenkins ' /etc/sudoers || echo 'jenkins ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers",
      "sudo mkdir -p /home/jenkins/.ssh",
      "sudo cat /tmp/jenkins.pub | sudo tee -a /home/jenkins/.ssh/authorized_keys > /dev/null",
      "sudo sort -u /home/jenkins/.ssh/authorized_keys -o /home/jenkins/.ssh/authorized_keys",
      "sudo chown -R jenkins:jenkins /home/jenkins/.ssh",
      "sudo chmod 700 /home/jenkins/.ssh",
      "sudo chmod 600 /home/jenkins/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  triggers_replace = {
    key_hash = filesha256(var.jenkins_pub_key_path)
  }

  depends_on = [aws_instance.csf_prod_vm]
}

resource "terraform_data" "install_docker" {
  provisioner "file" {
    source      = "${path.module}/docker_install.sh"
    destination = "/tmp/docker_install.sh"

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/docker_install.sh",
      "sudo /tmp/docker_install.sh"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  triggers_replace = {
    script_hash = filesha256("${path.module}/docker_install.sh")
  }

  depends_on = [aws_instance.csf_prod_vm]
}

resource "terraform_data" "install_nginx" {
  provisioner "file" {
    source      = "${path.module}/nginx_install.sh"
    destination = "/tmp/nginx_install.sh"

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx_install.sh",
      "sudo /tmp/nginx_install.sh"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  triggers_replace = {
    script_hash = filesha256("${path.module}/nginx_install.sh")
  }

  depends_on = [terraform_data.install_docker]
}

resource "terraform_data" "generate_jenkins_ssh_key_repo" {
  provisioner "remote-exec" {
    inline = [
      "sudo -u jenkins bash -c 'test -f /home/jenkins/.ssh/id_rsa || ssh-keygen -t rsa -b 4096 -C \"repo-key\" -N \"\" -f /home/jenkins/.ssh/id_rsa'"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  depends_on = [terraform_data.jenkins_user]
}

data "external" "jenkins_pubkey" {
  program = ["powershell", "-Command", <<-EOC
    $pubkey = ssh -o StrictHostKeyChecking=no -i '${var.csf_prod_vm_private_key_path}' ${var.csf_prod_vm_username}@${aws_instance.csf_prod_vm.private_ip} 'sudo cat /home/jenkins/.ssh/id_rsa.pub'
    Write-Output ('{ "pubkey": "' + $pubkey + '" }')
  EOC
  ]

  depends_on = [terraform_data.generate_jenkins_ssh_key_repo]
}

resource "terraform_data" "clone_repo" {
  count = var.enable_repo_clone ? 1 : 0

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /opt/CriticalSuccessFactors",
      "sudo chown jenkins:jenkins /opt/CriticalSuccessFactors",
      "sudo -u jenkins bash -c '[ -d /opt/CriticalSuccessFactors/.git ] || GIT_SSH_COMMAND=\"ssh -o StrictHostKeyChecking=no\" git clone git@github.com:completesolar/CriticalSuccessFactors.git /opt/CriticalSuccessFactors'"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  depends_on = [terraform_data.generate_jenkins_ssh_key_repo]
}

resource "terraform_data" "nginx_conf_setup" {
  provisioner "file" {
    source      = "${path.module}/prod-csf.conf"
    destination = "/tmp/prod-csf.conf"

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/prod-csf.conf /etc/nginx/sites-available/prod-csf.conf",
      "sudo ln -sf /etc/nginx/sites-available/prod-csf.conf /etc/nginx/sites-enabled/prod-csf.conf",
      "sudo nginx -t",
      "sudo systemctl reload nginx"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  triggers_replace = {
    conf_hash = filesha256("${path.module}/prod-csf.conf")
  }

  depends_on = [terraform_data.clone_repo]
}

resource "aws_lb_target_group" "csf_prod_vm_lb_tg" {
  name        = var.csf_prod_vm_lb_tg_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.prod_vpc_id
  target_type = "instance"
  health_check {
    protocol            = "HTTP"
    path                = "/healthz"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 10
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "csf_prod_vm_lb_tg_attach" {
  target_group_arn = aws_lb_target_group.csf_prod_vm_lb_tg.arn
  target_id        = aws_instance.csf_prod_vm.id
  port             = 80
}

resource "aws_lb_listener_rule" "csf_prod_vm_lb_listn_rule" {
  listener_arn = var.prod_lb_listn_arn
  priority     = 200
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.csf_prod_vm_lb_tg.arn
  }
  condition {
    host_header {
      values = [var.csf_prod_domain]
    }
  }
  tags = {
    Name = var.csf_prod_lb_listn_rule_name
  }
}

resource "terraform_data" "setup_jenkins_awscli_docker" {
  provisioner "remote-exec" {
    inline = [
      # Install dependencies if not already present
      "dpkg -s unzip curl ca-certificates >/dev/null 2>&1 || sudo apt-get update -y && sudo apt-get install -y unzip curl ca-certificates",

      # Download and install AWS CLI only if not installed
      "command -v aws >/dev/null 2>&1 || (curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o '/tmp/awscliv2.zip' && unzip -o /tmp/awscliv2.zip -d /tmp && sudo /tmp/aws/install --update)",

      # Create .aws directories for Jenkins user
      "sudo -u jenkins mkdir -p /home/jenkins/.aws",

      # Write credentials only if they don't already exist
      "sudo test -f /home/jenkins/.aws/credentials || (echo '[default]' | sudo tee /home/jenkins/.aws/credentials > /dev/null && echo 'aws_access_key_id = ${var.aws_access_key_id}' | sudo tee -a /home/jenkins/.aws/credentials > /dev/null && echo 'aws_secret_access_key = ${var.aws_secret_access_key}' | sudo tee -a /home/jenkins/.aws/credentials > /dev/null)",

      # Write config (region & output format) only if they don't already exist
      "sudo test -f /home/jenkins/.aws/config || (echo '[default]' | sudo tee /home/jenkins/.aws/config > /dev/null && echo 'region = ${var.aws_region}' | sudo tee -a /home/jenkins/.aws/config > /dev/null && echo 'output = json' | sudo tee -a /home/jenkins/.aws/config > /dev/null)",

      # Permissions
      "sudo chown -R jenkins:jenkins /home/jenkins/.aws",
      "sudo chmod 700 /home/jenkins/.aws",
      "sudo chmod 600 /home/jenkins/.aws/credentials",
      "sudo chmod 600 /home/jenkins/.aws/config",

      # Add jenkins to docker group if not already added
      "groups jenkins | grep -qw docker || sudo usermod -aG docker jenkins"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.csf_prod_vm.private_ip
      user        = var.csf_prod_vm_username
      private_key = file(var.csf_prod_vm_private_key_path)
    }
  }

  depends_on = [terraform_data.install_docker]
}
