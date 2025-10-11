terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = merge(
    {
      Project     = "adcash-gandalf"
      Environment = var.environment
    },
    var.extra_tags
  )
}

resource "aws_key_pair" "gandalf-key" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)

  tags = local.common_tags
}

resource "aws_security_group" "gandalf" {
  name        = "${var.resource_name_prefix}-sg"
  description = "Ingress rules for Gandalf Prometheus VM"
  vpc_id      = var.vpc_id

  tags = local.common_tags
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.gandalf.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_allowed_cidrs
  description       = "Allow SSH"
}

# resource "aws_security_group_rule" "http" {
#   type              = "ingress"
#   security_group_id = aws_security_group.gandalf.id
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = var.http_allowed_cidrs
#   description       = "Allow HTTP"
# }

resource "aws_security_group_rule" "prometheus" {
  type              = "ingress"
  security_group_id = aws_security_group.gandalf.id
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = var.http_allowed_cidrs
  description       = "Allow HTTP"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  security_group_id = aws_security_group.gandalf.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

resource "aws_instance" "gandalf" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.gandalf.id]
  key_name                    = aws_key_pair.gandalf-key.key_name
  associate_public_ip_address = var.associate_public_ip
  monitoring                  = var.enable_detailed_monitoring

  root_block_device {
    volume_size = var.root_volume_size_gb
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(local.common_tags, {
    Name = "${var.resource_name_prefix}-vm"
  })
}
