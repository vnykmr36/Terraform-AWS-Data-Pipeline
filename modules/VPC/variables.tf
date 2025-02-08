variable "environment" {
  type = map(string)
}

variable "vpc_config" {
  type = map(string)
}

variable "tags" {
  type        = map(string)
  description = "To create common tags against resources"
}
