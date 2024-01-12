resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    Description = var.vpc_description
  }
}
