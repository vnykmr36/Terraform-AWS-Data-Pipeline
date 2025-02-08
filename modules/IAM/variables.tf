variable "tags" {
  type        = map(string)
  description = "To create common tags against resources"
}

variable "kmskey" {
  type        = string
  description = "KMS key to encrypt resource"
}

variable "environment" {
  type = map(string)
  description = "To capture environment details"
}