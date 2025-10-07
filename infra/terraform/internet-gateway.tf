resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.fastfood-vpc.id

  tags = {
    Name = "${var.prefix}-fastfood-igw"
  }
}