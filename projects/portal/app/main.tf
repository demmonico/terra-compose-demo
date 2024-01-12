data "aws_vpc" "this" {
  filter {
    name   = "tag-key"
    values = ["Name"]
  }
  filter {
    name   = "tag-value"
    values = [var.vpc_name]
  }
}

resource "aws_security_group" "this" {
  name        = "${var.app}-${var.component}-${terraform.workspace}-sg"
  description = var.sg_description
  vpc_id      = data.aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
