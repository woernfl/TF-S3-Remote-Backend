######## AWS provider vars ########
# AWS Access Key 
variable "aws_access_key" {
  description = "AWS API Access Key"
}

# AWS Secret Key 
variable "aws_secret_key" {
  description = "AWS API Secret Key"
}

# AWS Region
variable "aws_region" {
  description = "AWS Region to deploy to"
}

######## Project vars ########
# Project name
variable "project_name" {
  description = "Name of the project"
}

# Project Owner
variable "project_owner" {
  description = "Owner of the project"
}