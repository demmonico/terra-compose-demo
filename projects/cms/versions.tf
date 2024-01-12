terraform {
  required_version = "~> 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "config" {
  source = "../../config"
}

provider "aws" {
  region = module.config.region
}
