module "images-sg" {
  source = "../../../modules/common/sg"

  sg_name  = "${var.app}-prod-${terraform.workspace}-sg"
  vpc_name = var.vpc_name
}
