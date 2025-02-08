output "key_id" {
  description = "The ID of the KMS key"
  value       = aws_kms_key.new_kms_key.id
}

output "key_arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.new_kms_key.arn
}