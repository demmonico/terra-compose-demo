terraform {
  required_version = "~> 1.3.4"

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

module "images-sg" {
  source = "../../../modules/common/sg"

  sg_name  = "${var.app}-staging-${terraform.workspace}-sg"
  vpc_name = var.vpc_name
}
