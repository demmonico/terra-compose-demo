terraform {
  required_version = "~> 1.2.1"

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

module "docs-sg" {
  source = "../../modules/common/sg"

  sg_name  = "${var.app}-${terraform.workspace}-sg"
  vpc_name = var.vpc_name
}
