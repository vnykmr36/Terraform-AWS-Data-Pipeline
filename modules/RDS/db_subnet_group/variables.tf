variable "vpc_id" {
  type = string
  description = "To get VPC ID information"
}

variable "privatesubnets" {
  type = list(string)
  description = "To get private subnets information"
}