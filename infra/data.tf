####
# AWS VPC
####

data "aws_vpc" "fastfood-soat-vpc" {
  filter {
    name   = "tag:Name"
    values = ["fastfood-vpc"]
  }
}

data "aws_subnets" "fastfood-soat-vpc-subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.fastfood-soat-vpc.id]
  }

  filter {
    name   = "tag:Type"
    values = ["public"]
  }
}