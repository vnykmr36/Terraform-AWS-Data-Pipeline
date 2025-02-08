output "ec2_id" {
  value = aws_instance.db_client_instance.id
}

output "ec2_public_url" {
  value = aws_instance.db_client_instance.public_ip
}