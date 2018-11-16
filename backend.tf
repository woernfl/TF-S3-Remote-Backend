# Decalaration of the terraform backend
terraform {
  backend "s3" {
    bucket         = "remote-state-me-us-east-1"
    encrypt        = true
    key            = "remote-state-me-us-east-1/backend/terraform.tfstate"
    dynamodb_table = "remote-state-me-us-east-1"
    region         = "us-east-1"
  }
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

# DynamoDB
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