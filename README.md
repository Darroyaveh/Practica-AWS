terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify a version constraint for the AWS provider
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Using default VPC and its subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "${var.instance_name_prefix}-sg"
  description = "Security group for EC2 instances"
  vpc_id      = data.aws_vpc.default.id # Ensure SG is in the default VPC

  ingress {
    description      = "Allow RDP from specified IP"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = [var.rdp_source_ip]
  }

  # Allow all traffic between instances in this security group
  ingress {
    description = "Allow all internal traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    self        = true # Allows traffic from resources with this SG ID
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # -1 means all protocols
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.instance_name_prefix}-sg"
  }
}

module "ec2_instances" {
  source                 = "./modules/ec2_instance"
  instance_count         = var.instance_count
  instance_type          = var.instance_type
  instance_name_prefix   = var.instance_name_prefix
  security_group_id      = aws_security_group.instance_sg.id
  # subnet_id can be omitted to use default subnet in an AZ,
  # or you could pick one from data.aws_subnets.default.ids list.
  # For simplicity, letting the module use its default (which means AWS picks a default subnet in an AZ)
  # If specific subnets are needed, this would be:
  # subnet_id = data.aws_subnets.default.ids[0] # Example: use the first default subnet
}
