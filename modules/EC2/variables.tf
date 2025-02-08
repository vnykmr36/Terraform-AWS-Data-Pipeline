variable "environment" {
  type        = map(string)
  description = "To get environment details"
}

variable "tags" {
  type        = map(string)
  description = "To create common tags against resources"
}

variable "vpc_config" {
  type        = map(string)
  description = "To get vpc related details"
}

variable "ec2_config" {
  type        = map(string)
  description = "To get ec2 related details"
}

variable "kms_key_id" {
  description = "KMS key ID for EBS encryption"
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID in VPC"
}

variable "security_group_id" {
  type        = string
  description = "Secruity ID in VPC"
}