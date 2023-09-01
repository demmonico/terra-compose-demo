variable "app" {
  type    = string
  default = "portal"
}

variable "component" {
  type    = string
  default = "app"
}

variable "sg_description" {
  type = string
}

variable "vpc_name" {
  type    = string
  default = "nonprod-vpc"
}
