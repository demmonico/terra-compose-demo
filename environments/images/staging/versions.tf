terraform {
  required_version = "~> 1.3.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "config" {
  source = "../../../config"
}

provider "aws" {
  region = module.config.region
}
