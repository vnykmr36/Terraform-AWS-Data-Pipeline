output "vpc_id" {
  value       = aws_vpc.tfm_vpc.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.publicsubs[*].id
  description = "The public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.privatesubs[*].id
  description = "The private subnets"
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.tfm_vpc.cidr_block
}

output "security_group_id" {
  value = aws_vpc.tfm_vpc.default_security_group_id
}