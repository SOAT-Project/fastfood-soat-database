resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.fastfood-vpc.id
  cidr_block              = var.public_subnet_a_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az_a

  tags = {
    Name                                               = "${var.prefix}-public-subnet-a"
    Type                                               = "public"
    "kubernetes.io/cluster/${var.prefix}-fastfood-eks" = "shared"
    "kubernetes.io/role/elb"                           = "1"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.fastfood-vpc.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.az_b
  map_public_ip_on_launch = true

  tags = {
    Name                                               = "${var.prefix}-public-subnet-b"
    Type                                               = "public"
    "kubernetes.io/cluster/${var.prefix}-fastfood-eks" = "shared"
    "kubernetes.io/role/elb"                           = "1"
  }
}