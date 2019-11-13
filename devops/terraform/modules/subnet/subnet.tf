resource "aws_subnet" "eks-cluster-subnet-private" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${var.vpc_id}"

  tags = "${
    map(
      "Name", "eks-cluster-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "eks-cluster-subnet-public" {
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block        = "${var.public-cidr}"
  vpc_id            = "${var.vpc_id}"

  tags = "${
    map(
      "Name", "eks-cluster-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "eks-cluster-igw" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "eks-cluster-igw"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "eks-cluster-natgw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = aws_subnet.eks-cluster-subnet-public.id
  depends_on    = ["aws_internet_gateway.eks-cluster-igw"]
  tags = {
    Name = "eks-cluster-natgw"
  }
}


resource "aws_route_table" "eks-cluster-routetable-private" {
  vpc_id = "${var.vpc_id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.eks-cluster-natgw.id}"
  }

  tags = {
    Name = "eks-cluster-routetable-private"
  }
}

resource "aws_route_table_association" "privatesubnet_rt_table_assocation" {
  count = 2
  subnet_id      = "${aws_subnet.eks-cluster-subnet-private.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks-cluster-routetable-private.id}"
}

resource "aws_route_table" "eks-cluster-routetable-public" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks-cluster-igw.id}"
  }
}

resource "aws_route_table_association" "routetable-association-public" {
  subnet_id      = "${aws_subnet.eks-cluster-subnet-public.id}"
  route_table_id = "${aws_route_table.eks-cluster-routetable-public.id}"
}

