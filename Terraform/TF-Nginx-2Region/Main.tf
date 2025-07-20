provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "usw2"
  region = "us-west-2"
}

# Fetch latest Amazon Linux 2 AMI via SSM
data "aws_ssm_parameter" "use1_ami" {
  provider = aws.use1
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "usw2_ami" {
  provider = aws.usw2
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Default VPC retrieval
data "aws_vpc" "use1" {
  provider = aws.use1
  default  = true
}

data "aws_vpc" "usw2" {
  provider = aws.usw2
  default  = true
}

# Security Groups
resource "aws_security_group" "use1_sg" {
  provider = aws.use1
  name     = "nginx-sg-use1"
  vpc_id   = data.aws_vpc.use1.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
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
}

resource "aws_security_group" "usw2_sg" {
  provider = aws.usw2
  name     = "nginx-sg-usw2"
  vpc_id   = data.aws_vpc.usw2.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
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
}

# EC2 Instances
resource "aws_instance" "use1_nginx" {
  provider        = aws.use1
  ami             = data.aws_ssm_parameter.use1_ami.value
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.use1_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = { Name = "nginx-use1" }
}

resource "aws_instance" "usw2_nginx" {
  provider        = aws.usw2
  ami             = data.aws_ssm_parameter.usw2_ami.value
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.usw2_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = { Name = "nginx-usw2" }
}

# Outputs
output "us_east_instance_ip" {
  value = aws_instance.use1_nginx.public_ip
}

output "us_west_instance_ip" {
  value = aws_instance.usw2_nginx.public_ip
}
