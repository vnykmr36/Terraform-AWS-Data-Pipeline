environment = {
  name   = "dev"
  region = "us-west-2"
}

vpc_config = {
  vpc_cidr = "10.0.0.0/16"
}

ec2_config = {
  instance_type = "t3.micro"
  volume_size   = 10
  volume_type   = "gp2"
}

rds_config = {
  instance_class    = "db.t3.small"
  engine            = "postgres"
  engine_version    = "16.3"
  port              = 5432
  allocated_storage = 20
}

common_tags = {
  Environment = "dev"
  Terraform   = "true"
}

key_admin = {
  admin = "DBEngg"
  user  = "OpsTeam"
}

dms_details = {
  ri_version     = "3.5.4"
  instance_class = "dms.t3.small"
}