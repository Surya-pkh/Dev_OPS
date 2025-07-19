🚀 Deploying My DevOps Portfolio to AWS using Terraform
This guide walks you through deploying a static portfolio website to Amazon S3 using Terraform.

🧰 Prerequisites
Make sure the following are installed and configured:

✅ Terraform

✅ AWS CLI

✅ AWS credentials configured:


📁 Project Structure:

my-portfolio/
├── frontend/
│   ├── build/
│   │   └── index.html      # Your website content
│   └── package.json        # Optional metadata
├── terraform/
│   ├── main.tf             # Terraform code
│   └── variables.tf        # Input variable definitions


📝 Step 1: Prepare Frontend Files

Put your website HTML/CSS files in:

frontend/build/index.html
You can use any static HTML, like the one we created with Tailwind + AOS.

⚙️ Step 2: Create Terraform Files

terraform/variables.tf

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

terraform/main.tf

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "portfolio" {
  bucket = "my-portfolio-unique-123456"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "public" {
  bucket                  = aws_s3_bucket.portfolio.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.portfolio.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  depends_on = [aws_s3_bucket_public_access_block.public]

  bucket = aws_s3_bucket.portfolio.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.portfolio.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "build_files" {
  for_each = fileset("../frontend/build", "**")

  bucket       = aws_s3_bucket.portfolio.id
  key          = each.value
  source       = "../frontend/build/${each.value}"
  content_type = "text/html"
}

output "website_url" {
  value = "http://${aws_s3_bucket.portfolio.bucket}.s3-website.${var.region}.amazonaws.com"
}
🔁 Update the bucket name to something globally unique.

📦 Step 3: Initialize and Apply Terraform

cd terraform
terraform init
terraform apply

Type yes to confirm.

After a minute, Terraform will output your public website URL:
Apply complete! Resources: X added.
Outputs:
website_url = http://your-bucket-name.s3-website-us-east-1.amazonaws.com

🎉 Step 4: Open Your Website
Visit the URL printed by Terraform — your DevOps portfolio site is now live!

🧼 Cleanup (optional)

To delete everything:

terraform destroy
