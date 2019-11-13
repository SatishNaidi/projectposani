variable "vpc_id" {}
variable "subnet_id" {}
variable "subnet_id_public" {}

variable "external_cidr" {
  default = ["0.0.0.0/0"]
}
