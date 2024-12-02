provider "aws" {
  region = var.region
}

resource "aws_vpc" "example_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.environment}-subnet"
  }
}

resource "aws_security_group" "example_sg" {
  name        = "${var.environment}-sg"
  vpc_id      = aws_vpc.example_vpc.id
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-sg"
  }
}

resource "aws_instance" "example_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.example_subnet.id

  # Correcting this to use security_group_ids
  security_group_ids = [aws_security_group.example_sg.id]

  tags = {
    Name = "${var.environment}-instance"
    Environment = var.environment
  }
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.example_instance.public_ip
}
