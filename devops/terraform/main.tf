module "vpc" {
  source = "./modules/vpc"
  cluster-name = "${module.cluster.cluster-name}"
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.vpc_id}"
  cluster-name = "${module.cluster.cluster-name}"
}

module "securitygroup" {
  source = "./modules/securitygroup"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_id = "${module.subnet.subnet_id}"
  subnet_id_public = "${module.subnet.subnet_id}"
}

module "iam" {
  source = "./modules/iam"
}

module "cluster" {
  source = "./modules/cluster"
  eks-cluster-securitygroup = "${module.securitygroup.eks-cluster-securitygroup}"
  subnet_id = "${module.subnet.subnet_id}"
  cluster_policy = "${module.iam.cluster_policy}"
  service_policy = "${module.iam.service_policy}"
  eks-cluster-iamrole = "${module.iam.eks-cluster-iamrole}"
}

module "workernode" {
  source = "./modules/workernode"
  subnet_id = "${module.subnet.subnet_id}"
  cluster-name = "${module.cluster.cluster-name}"
  eks-cluster = "${module.cluster.eks-cluster}"
  eks-cluster-node-instanceprofile = "${module.iam.eks-cluster-node-instanceprofile}"
  eks-cluster-node = "${module.securitygroup.eks-cluster-node}"
}
