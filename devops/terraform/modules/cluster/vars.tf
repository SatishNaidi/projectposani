variable "cluster-name" {
  default = "tradeling-eks-cluster"
}

variable "eks-cluster-securitygroup" {}
variable "eks-cluster-iamrole" {}
variable "subnet_id" {}

variable "cluster_policy" {}
variable "service_policy" {}
