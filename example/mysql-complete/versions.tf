# Terraform version
terraform {
  required_version = ">= 1.12.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta3"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}