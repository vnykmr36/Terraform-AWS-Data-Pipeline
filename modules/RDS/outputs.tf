output "rds_endpoint" {
  value = aws_db_instance.rdb_pg_inst.address
}

output "rds_port" {
  value = aws_db_instance.rdb_pg_inst.port
}

output "rds_user" {
  value = aws_db_instance.rdb_pg_inst.username
}

output "rds_dbname" {
  value = aws_db_instance.rdb_pg_inst.db_name
}

output "rds_secret_arn" {
  value = aws_db_instance.rdb_pg_inst.master_user_secret[0].secret_arn
}
