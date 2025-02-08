module "subnet_group" {
  source         = "./db_subnet_group"
  vpc_id         = var.vpc_id
  privatesubnets = var.privatesubnets
}

module "parameter_group" {
  source        = "./db_parameter_group"
  engine        = var.rds_config.engine
  engineversion = var.rds_config.engine_version
}

resource "aws_db_instance" "rdb_pg_inst" {
  depends_on                  = [module.subnet_group, module.parameter_group]
  engine                      = var.rds_config.engine
  instance_class              = var.rds_config.instance_class
  identifier                  = "${var.rds_config.engine}-prd"
  engine_version              = var.rds_config.engine_version
  tags                        = var.tags
  multi_az                    = false
  kms_key_id                  = var.kmskey
  manage_master_user_password = true
  storage_encrypted           = true
  username                    = "postgres"
  allocated_storage           = var.rds_config.allocated_storage
  parameter_group_name        = module.parameter_group.parameter_group_name
  db_subnet_group_name        = module.subnet_group.subnet_group_name
  backup_retention_period     = 1
  allow_major_version_upgrade = false
  port                        = var.rds_config.port
  vpc_security_group_ids      = var.security_group_id
  apply_immediately           = true
  skip_final_snapshot         = true
  db_name = "${var.rds_config.engine}"
}
