locals {
  version = replace(var.dms_details.ri_version,".","")
  }

module "subnet_group" {
  source = "./dms_subnet_group"
  vpc_id = var.vpc_id
  privatesubnets = var.privatesubnets
}

data "aws_secretsmanager_secret_version" "get_secret" {
  secret_id = "${var.rds_secret_arn}"
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.rds_config.engine}-db_secrets"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "secretdata" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    "username": var.rds_user,
    "password": jsondecode(data.aws_secretsmanager_secret_version.get_secret.secret_string)["password"],
    "port": var.rds_config.port, 
    "host": var.rds_endpoint
    })
}

resource "aws_dms_endpoint" "pg_source" {
  tags = var.tags
  engine_name = var.rds_config.engine
  endpoint_type = "source"
  endpoint_id = "source-${var.rds_config.engine}-${local.version}-${var.environment.name}"
  secrets_manager_access_role_arn = "${var.iam_role_arn}"
  secrets_manager_arn = aws_secretsmanager_secret.db_secret.arn
  database_name = var.rds_dbname
}

resource "aws_dms_s3_endpoint" "s3_target" {
  tags = var.tags
  endpoint_type = "target"
  endpoint_id = "target-s3-dlake"
  bucket_name = var.bucket
  service_access_role_arn = var.iam_role_arn
  cdc_inserts_and_updates = false
  data_format = "parquet"
  date_partition_enabled = true
}

resource "aws_dms_replication_instance" "tfm_ri" {
  replication_instance_class = var.dms_details.instance_class
  replication_subnet_group_id = module.subnet_group.subnet_group_id
  engine_version = var.dms_details.ri_version
  replication_instance_id = "dms-rep-${local.version}"
  apply_immediately = true
  tags = var.tags
  multi_az = false
  publicly_accessible = false
  vpc_security_group_ids = var.security_group_id
}

resource "aws_dms_replication_task" "dms_task" {
  replication_instance_arn = aws_dms_replication_instance.tfm_ri.replication_instance_arn
  source_endpoint_arn = aws_dms_endpoint.pg_source.endpoint_arn
  target_endpoint_arn = aws_dms_s3_endpoint.s3_target.endpoint_arn
  replication_task_id = "dms-pg-to-s3"
  replication_task_settings = file("${path.root}/modules/DMS/replication_task_settings.json")
  migration_type = "full-load-and-cdc"
  table_mappings = file("${path.root}/modules/DMS/table_mappings.json")
  start_replication_task = true
}