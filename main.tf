data "aws_ami" "windows_server" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "app_server" {
  count         = var.instance_count
  ami           = data.aws_ami.windows_server.id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id     = var.subnet_id # Allows specifying a subnet, or using default if null

  associate_public_ip_address = true # Ensure public IP is assigned

  tags = {
    Name = "${var.instance_name_prefix}-${count.index + 1}"
  }
}
