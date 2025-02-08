variable "tags" {
  type        = map(string)
  description = "To create common tags against resources"
}

variable "kms_key_id" {
  type        = string
  description = "KMS key to encrypt resource"
}

variable "rds_config" {
  type = map(string)
  description = "To capture RDS DB Instance details"
}

variable "environment" {
  type = map(string)
  description = "To capture environment details"
}

variable "iam_role_arn" {
  type = string
  description = "To get IAM role to be passed with endpoint for connection establishment"
}

variable "rds_secret_arn" {
  type = string
  description = "Get RDS Secret details"
}

variable "dms_details" {
  type = map(string)
  description = "DMS Environment specific details"
}

variable "vpc_id" {
  type = string
  description = "Get VPC information"
}

variable "privatesubnets" {
  type = list(string)
  description = "Get Private subnet details"
}

variable "security_group_id" {
  type = list(string)
  description = "Get Security group details"
}

variable "bucket" {
  type = string
  description = "Configuring S3 target bucket information"
}

variable "rds_user" {
  type = string
  description = "Get RDS username to connect"
}

variable "rds_endpoint" {
  type = string
  description = "Get RDS endpoint URL to connect"
}

variable "rds_dbname" {
  type = string
  description = "Get RDS DB name to connect"
}
