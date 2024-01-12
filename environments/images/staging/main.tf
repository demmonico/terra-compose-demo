module "images-sg" {
  source = "../../../modules/common/sg"

  sg_name  = "${var.app}-staging-${terraform.workspace}-sg"
  vpc_name = var.vpc_name
}
