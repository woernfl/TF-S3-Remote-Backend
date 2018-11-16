# Terraformf S3 remote backend example

## Prerequisites

- Install Tarraform: <https://www.terraform.io/intro/getting-started/install.html>

## Create S3 bucket and DynamoDB table

You can use the default terraform.tfvars.example file (just need to add AWS keys and remove the .example from the file name). If you prefere to use cmd arguments, that's up to you.

Go in the `backend.tf` file and **comment** the following block of code

```tf
terraform {
  backend "s3" {
    bucket         = "remote-state-me-us-east-1"
    encrypt        = true
    key            = "remote-state-me-us-east-1/backend/terraform.tfstate"
    dynamodb_table = "remote-state-me-us-east-1"
    region         = "us-east-1"
  }
}
```

Initiatialize Terraform project by importing the nessecary provider

```bash
terraform init
```

Check the S3 bucket and DynamoDB table that will be created

```bash
terraform plan
```

Create the S3 bucket and DynamoDB table

```bash
terraform apply -auto-approve
```

Go in the `backend.tf` file and **uncomment** the following block of code

```tf
terraform {
  backend "s3" {
    bucket         = "remote-state-me-us-east-1"
    encrypt        = true
    key            = "remote-state-me-us-east-1/backend/terraform.tfstate"
    dynamodb_table = "remote-state-me-us-east-1"
    region         = "us-east-1"
  }
}
```

Modify the various informations. Here is a maping of what is corresponding to what:

- `bucket`: name of the S3 bucket to push the state to
- `encrypt`: make sure that the `terraform.tfstate` file is encrypted on the S3 bucket
- `key`: path on the S3 bucket where the `terraform.tfstate` file will be stored (it is up to you to define it, I strongly encourage you to follow a patern)
- `dynamodb_table`: name of the DynamoDB table used to lock the state during Terraform operations
- `region`: region where the S3 bucket is

Reinitiatialize the Terraform project to push the local state to the S3 bucket

```bash
terraform init
```

When asked, agree to push your local `terraform.tfstate` file to the remote S3 bucket.

## Delete S3 bucket and DynamoDB table

Go in the `backend.tf` file and *comment* the following block of code, it is present in the S3 bucket and in the DynamoDB table ressources, so you will have to comment it in both places

```tf
lifecycle {
  prevent_destroy = true
}
```

Delete previously created DynamoDB table

```bash
terraform destroy -force
```

You will get an error, but the DynamoDB table will have been deleted. Go to your AWS console and manually delete the S3 bucket where you used to store the `terraform.tfstate` file.

## Bonus

Install autocompletion for terraform:

```bash
terraform -install-autocomplete
```

## Want more

You have a project? Want to discuss? Contact me at <hello@onmyown.io>
