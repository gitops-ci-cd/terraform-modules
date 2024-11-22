terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket     = "my-terraform-state"
    key        = "state/terraform.tfstate"
    region     = "us-east-1"
    access_key = "mock_access_key"
    secret_key = "mock_secret_key"
    endpoints = {
      s3 = "http://localhost:4566"
    }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    use_path_style              = true
    skip_requesting_account_id  = true
  }

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}
