terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "mike_ssh" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}

resource "aws_security_group" "web_instance" {
  name = "web-instance"

  ingress {
    from_port   = var.web_server_port
    to_port     = var.web_server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-08e2c1a8d17c2fe17"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.web_server_port} &
              EOF
  user_data_replace_on_change = true

  tags = {
    Name = "web_server"
  }
  vpc_security_group_ids = [aws_security_group.mike_ssh.id,aws_security_group.web_instance.id]

}

# generate inventory file for Ansible
resource "local_file" "inventory_ini" {
  content = templatefile("${path.module}/inventory.tpl",
    {
      web_servers = aws_instance.web_server.*.public_dns
    }
  )
  filename = "inventory.ini"
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

variable "web_server_port" {
  description = "The port the web server will use for HTTP requests."
  type = number
  default = 8080
}
