resource "aws_vpc" "fastfood-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-fastfood-vpc"
  }
}