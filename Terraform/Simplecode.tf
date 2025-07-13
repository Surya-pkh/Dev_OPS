# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # You can change this to your desired AWS region
}

# --- Data Source to find the latest Amazon Linux 2 AMI ---
# This data source dynamically fetches the most recent Amazon Linux 2 AMI.
# It's good practice to use data sources for AMIs to ensure you're always using an up-to-date image.
data "aws_ami" "amazon_linux_2" {
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

# --- Security Group for Apache Web Server ---
# This resource creates a new security group named "ApacheWebSG-Terraform".
# It allows inbound HTTP traffic on port 80 from any IP address (0.0.0.0/0).
# It also allows all outbound traffic.
resource "aws_security_group" "apache_web_sg" {
  name        = "ApacheWebSG-Terraform"
  description = "Allow HTTP inbound traffic for Apache web server"

  # Inbound rule for HTTP (Port 80)
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows access from any IPv4 address
  }

  # Inbound rule for SSH (Port 22) - Optional, but highly recommended for management
  ingress {
    description = "SSH from your IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # IMPORTANT: Replace "0.0.0.0/0" with your actual public IP address CIDR (e.g., "YOUR_IP_ADDRESS/32")
    # for better security. Using 0.0.0.0/0 allows SSH from anywhere.
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule (allows all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ApacheWebSG-Terraform"
  }
}

# --- EC2 Instance for Apache Web Server ---
# This resource creates an EC2 instance.
# It uses the latest Amazon Linux 2 AMI found by the data source.
# It attaches the security group created above.
# The user_data script installs Apache, starts it, enables it, and creates a simple index.html.
resource "aws_instance" "apache_web_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro" # A free tier eligible instance type

  # Associate the security group
  vpc_security_group_ids = [aws_security_group.apache_web_sg.id]

  # IMPORTANT: Replace "your-key-pair-name" with the name of an existing EC2 key pair in your AWS account.
  # This key pair is necessary for SSH access to the instance.
  key_name = "your-key-pair-name"

  # User data script to install and configure Apache
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Hello from your EC2 Apache Web Server deployed with Terraform!</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "ApacheWebInstance-Terraform"
  }
}

# --- Output the Public IP Address ---
# This output block makes the public IP address of the EC2 instance easily accessible
# after Terraform applies the configuration.
output "public_ip_address" {
  description = "The public IP address of the Apache web server"
  value       = aws_instance.apache_web_server.public_ip
}