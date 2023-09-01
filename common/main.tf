terraform {
  required_version = "~> 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

#-------------------------------------#

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    Description = var.vpc_description
  }
}
