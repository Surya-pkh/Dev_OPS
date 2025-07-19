provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "portfolio" {
  bucket = "my-portfolio-unique-123456191140"
  force_destroy = true

  tags = {
    Name = "Portfolio Website"
  }
}

# NEW: Explicitly disable block public access (allows public-read policies)
resource "aws_s3_bucket_public_access_block" "public" {
  bucket                  = aws_s3_bucket.portfolio.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# NEW: Website hosting configuration (not deprecated)
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.portfolio.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# NEW: Bucket policy to allow public read
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

# NEW: Upload files without ACLs (modern object ownership)
resource "aws_s3_object" "build_files" {
  for_each = fileset("../frontend/build", "**")

  bucket       = aws_s3_bucket.portfolio.id
  key          = each.value
  source       = "../frontend/build/${each.value}"
  content_type = "text/html"
}

output "website_url" {
  value = "http://${aws_s3_bucket.portfolio.bucket}.s3-website.us-east-1.amazonaws.com"
}
