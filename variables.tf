variable "environment" {
  type        = map(string)
  description = "Environment name (dev/qa/prod)"
}

variable "vpc_config" {
  type = map(string)
  description = "CIDR block for VPC"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for all resources"
}

variable "rds_config" {
  type        = map(string)
  description = "RDS config information"
}

variable "ec2_config" {
  type        = map(string)
  description = "EC2 config information"
}

variable "key_admin" {
  type = map(string)
}

variable "dms_details" {
  type = map(string)
}