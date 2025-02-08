variable "rds_config" {
  type = map(string)
  description = "To get RDS details"
}

variable "tags" {
  type        = map(string)
  description = "To create common tags against resources"
}

variable "random_text" {
  type = string
  description = "To use random text"
}