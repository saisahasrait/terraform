provider "aws" {
  allowed_account_ids = ["499015291023"]
  profile             = "terraform"
  region              = "eu-west-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.21"
    }
  }
}