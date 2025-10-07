resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.fastfood-vpc.id
  cidr_block              = var.private_subnet_a_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.az_a

  tags = {
    Name                                               = "${var.prefix}-private-subnet-a"
    Type                                               = "private"
    "kubernetes.io/cluster/${var.prefix}-fastfood-eks" = "shared"
    "kubernetes.io/role/internal-elb"                  = "1"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.fastfood-vpc.id
  cidr_block              = var.private_subnet_b_cidr
  availability_zone       = var.az_b
  map_public_ip_on_launch = false

  tags = {
    Name                                               = "${var.prefix}-private-subnet-b"
    Type                                               = "private"
    "kubernetes.io/cluster/${var.prefix}-fastfood-eks" = "shared"
    "kubernetes.io/role/internal-elb"                  = "1"
  }
}