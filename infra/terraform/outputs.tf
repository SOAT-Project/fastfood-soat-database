output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.fastfood-vpc.id
}

output "public_subnets_ids" {
  description = "IDs das subnets públicas"
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "private_subnets_ids" {
  description = "IDs das subnets privadas"
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.postgres.endpoint
}
