####
# DATABASE
####

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

####
# SECURITY GROUP
####

variable "allowed_cidr" {
  description = "CIDR allowed to access RDS (ex: seu IP público)"
  type        = string
  default     = "0.0.0.0/0"
}