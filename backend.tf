# Decalaration of the terraform backend
# terraform {
#   backend "s3" {
#     bucket         = "remote-state-test01-me-us-east-1"
#     encrypt        = true
#     key            = "remote-state-test01-me-us-east-1/backend/terraform.tfstate"
#     dynamodb_table = "remote-state-test01-me-us-east-1"
#     region         = "us-east-1"
#   }
# }

# Get current user canonical ID
data "aws_canonical_user_id" "current" {}

# S3 bucket policy template file creation
data "template_file" "tf_state_bucket_policy_template" {
  template = "${file("${path.module}/policy/s3.tpl")}"

  vars {
    s3_bucket_name = "${aws_s3_bucket.tf_state_bucket.id}"
    canonical_user_id = "${data.aws_canonical_user_id.current.id}"
  }
}

# S3 buccket policy creation
resource "aws_s3_bucket_policy" "tf_state_bucket_policy" {
  bucket = "${aws_s3_bucket.tf_state_bucket.id}"

  policy = "${data.template_file.tf_state_bucket_policy_template.rendered}"
}

# AWS S3 bucket creation
resource "aws_s3_bucket" "tf_state_bucket" {
  bucket  = "${var.project_name}-${var.project_owner}-${var.aws_region}"
  acl     = "private"

  tags {
    Name  = "${var.project_name}"
    Owner = "${var.project_owner}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  
  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

# DynamoDB table creation
resource "aws_dynamodb_table" "tf_state_dynamodb" {
  name           = "${var.project_name}-${var.project_owner}-${var.aws_region}"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
 
  attribute {
    name         = "LockID"
    type         = "S"
  }
 
  tags {
    Name         = "${var.project_name}"
    Owner        = "${var.project_owner}"
  }

  lifecycle {
    prevent_destroy = true
  }
}