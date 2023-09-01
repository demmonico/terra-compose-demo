variable "app" {
  type    = string
  default = "runners"
}

variable "sg_description" {
  type = string
}

variable "vpc_name" {
  type    = string
  default = "nonprod-vpc"
}
