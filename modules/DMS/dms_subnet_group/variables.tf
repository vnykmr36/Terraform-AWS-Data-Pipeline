variable "vpc_id" {
  type = string
  description = "Get VPC information"
}

variable "privatesubnets" {
  type = list(string)
  description = "Get Private subnet details"
}