
provider "http" {}

#Create the VPC
resource "aws_vpc" "eks-cluster-vpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = "${
    map(
      "Name", "eks-cluster-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}
