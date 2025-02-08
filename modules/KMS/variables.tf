variable "tags" {
  type        = map(string)
  description = "To create common tags against resources"
}

variable "key_admin" {
  type = map(string)
  description = "To capture Key admin details"
}