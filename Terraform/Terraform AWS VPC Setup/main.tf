# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Create VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "custom-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "custom-igw"
  }
}

# Create Public Subnet in us-west-2a
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-us-west-2a"
  }
}

# Create Private Subnet in us-west-2b
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "private-subnet-us-west-2b"
  }
}

# Create Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Create Route Table for Private Subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "private-route-table"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Security Group for Public Instance
resource "aws_security_group" "public_sg" {
  name        = "public-instance-sg"
  description = "Security group for public instance"
  vpc_id      = aws_vpc.custom_vpc.id

  # Allow SSH from internet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP from internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS from internet
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-instance-sg"
  }
}

# Security Group for Private Instance
resource "aws_security_group" "private_sg" {
  name        = "private-instance-sg"
  description = "Security group for private instance"
  vpc_id      = aws_vpc.custom_vpc.id

  # Allow SSH only from public instance
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  # Allow ICMP (ping) from public instance
  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.public_sg.id]
  }

  # Allow HTTP from public instance
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  # Allow outbound traffic to VPC CIDR (for package updates via NAT if needed)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "private-instance-sg"
  }
}

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create Key Pair (you'll need to create this in AWS Console or provide your own)
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "custom-vpc-key"
  public_key = file("custom-vpc-key.pub") # Using local file in terraform directory
}

# EC2 Instance in Public Subnet
resource "aws_instance" "public_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = aws_key_pair.ec2_key_pair.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Public Instance in us-west-2a</h1>" > /var/www/html/index.html
              echo "<p>This is the public instance that can access the private instance.</p>" >> /var/www/html/index.html
              EOF

  tags = {
    Name = "public-instance"
  }
}

# EC2 Instance in Private Subnet
resource "aws_instance" "private_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.ec2_key_pair.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Private Instance in us-west-2b</h1>" > /var/www/html/index.html
              echo "<p>This is the private instance accessible only from the public instance.</p>" >> /var/www/html/index.html
              EOF

  tags = {
    Name = "private-instance"
  }
}

# Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.custom_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

output "public_instance_id" {
  description = "ID of the public instance"
  value       = aws_instance.public_instance.id
}

output "private_instance_id" {
  description = "ID of the private instance"
  value       = aws_instance.private_instance.id
}

output "public_instance_public_ip" {
  description = "Public IP of the public instance"
  value       = aws_instance.public_instance.public_ip
}

output "public_instance_private_ip" {
  description = "Private IP of the public instance"
  value       = aws_instance.public_instance.private_ip
}

output "private_instance_private_ip" {
  description = "Private IP of the private instance"
  value       = aws_instance.private_instance.private_ip
}

output "ssh_command_public" {
  description = "SSH command to connect to public instance"
  value       = "ssh -i custom-vpc-key ec2-user@${aws_instance.public_instance.public_ip}"
}

output "ssh_command_private_via_public" {
  description = "SSH command to connect to private instance via public instance"
  value       = "ssh -i custom-vpc-key -o ProxyCommand='ssh -i custom-vpc-key -W %h:%p ec2-user@${aws_instance.public_instance.public_ip}' ec2-user@${aws_instance.private_instance.private_ip}"
}