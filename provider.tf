# AWS Provider Tanımı
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider Konfigürasyonu
provider "aws" {
  region = var.aws_region
}

