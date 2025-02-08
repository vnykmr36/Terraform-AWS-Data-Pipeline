variable "tags" {
  type        = map(string)
  description = "To create common tags against resources"
}

variable "kmskey" {
  type        = string
  description = "KMS key to encrypt resource"
}

variable "rds_config" {
  type = map(string)
  description = "Get RDS Configuration"
}

variable "vpc_id" {
  type = string
  description = "Get VPC ID"
}

variable "privatesubnets" {
  type = list(string)
  description = "Get subnets for creating subnet group"
}

variable "security_group_id" {
  type = list(string)
  description = "Get Security group Id for assigning"
}