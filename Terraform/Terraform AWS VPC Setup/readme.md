🚀 Terraform AWS VPC Setup
This project provisions a custom VPC in AWS with the following components using Terraform:

One VPC with public and private subnets

Internet Gateway, route tables, and associations

Security Groups for public and private EC2 instances

Amazon Linux 2 EC2 instances (public and private)

User data for Apache installation on both instances

Key pair for SSH access

Output instructions to connect to the instances

🛠️ Requirements
Terraform

AWS CLI configured with IAM credentials

An AWS public key file (custom-vpc-key.pub) in the root directory

📁 File Structure
graphql
Copy
Edit
.
├── main.tf              # Main infrastructure configuration
├── outputs.tf           # Output values like instance IPs and SSH commands
├── variables.tf         # (Optional) Input variables if refactored
├── custom-vpc-key.pub   # Your SSH public key for EC2 access
└── README.md            # Project documentation
🌐 Infrastructure Components
VPC & Networking
VPC: 10.0.0.0/16

Public Subnet: 10.0.1.0/24 (us-west-2a)

Private Subnet: 10.0.2.0/24 (us-west-2b)

Internet Gateway for public subnet routing

Route Tables:

Public: Routes to Internet Gateway

Private: No internet access

Security Groups
Public SG: Allows SSH (22), HTTP (80), HTTPS (443) from anywhere

Private SG: Allows traffic only from the public instance (SSH, HTTP, ICMP)

EC2 Instances
Public Instance:

In public subnet

Runs Apache server with a simple HTML page

Private Instance:

In private subnet

Only accessible via public instance

⚙️ Setup Instructions
1. Clone the Repository
bash
Copy
Edit
git clone https://github.com/your-username/terraform-aws-vpc-setup.git
cd terraform-aws-vpc-setup
2. Ensure Public Key Exists
Place your SSH public key in the root directory with the filename:

vbnet
Copy
Edit
custom-vpc-key.pub
Note: You must generate this key using ssh-keygen if it doesn't exist.

3. Initialize Terraform
bash
Copy
Edit
terraform init
4. Validate and Plan
bash
Copy
Edit
terraform plan
5. Apply Infrastructure
bash
Copy
Edit
terraform apply -auto-approve
🔓 Access Information
Once deployed, Terraform will output:

Public IP of the public instance

Private IPs of both instances

SSH commands to connect

Connect to Public Instance
bash
Copy
Edit
ssh -i custom-vpc-key ec2-user@<public_instance_ip>
Connect to Private Instance (via Public)
bash
Copy
Edit
ssh -i custom-vpc-key -o ProxyCommand="ssh -i custom-vpc-key -W %h:%p ec2-user@<public_instance_ip>" ec2-user@<private_instance_ip>
🧹 Clean Up
To destroy the infrastructure:

bash
Copy
Edit
terraform destroy -auto-approve
📌 Notes
Make sure your AWS region is set to us-west-2

The AMI used is the latest Amazon Linux 2

Ensure that your local IP is allowed if you later restrict the public SG for security

