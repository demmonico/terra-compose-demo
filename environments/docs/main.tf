module "docs-sg" {
  source = "../../modules/common/sg"

  sg_name  = "${var.app}-${terraform.workspace}-sg"
  vpc_name = var.vpc_name
}
