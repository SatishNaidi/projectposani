output "eks-cluster-securitygroup" {
  value = "${aws_security_group.eks-cluster-securitygroup}"
}

output "eks-cluster-node" {
  value = "${aws_security_group.eks-cluster-node}"
}
