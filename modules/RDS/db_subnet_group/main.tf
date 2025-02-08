resource "aws_db_subnet_group" "subnet_grp" {
  name       = "default-${var.vpc_id}"
  subnet_ids = var.privatesubnets
  tags = {
    "Name" = "DB Subnet Group"
  }
}