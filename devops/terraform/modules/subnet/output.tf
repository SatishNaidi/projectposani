output "subnet_id" {
  value = "${aws_subnet.eks-cluster-subnet-private[*].id}"
}

output "subnet_id_public" {
  value = "${var.public-cidr}" 
}
