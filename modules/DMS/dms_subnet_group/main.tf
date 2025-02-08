resource "aws_dms_replication_subnet_group" "subnet_grp" {
  subnet_ids = var.privatesubnets
  tags = {
    "Name" = "DMS Subnet Group"
  }
  replication_subnet_group_description = "Default subnet group"
  replication_subnet_group_id          = "dms-subnet-group-${var.vpc_id}"
}
