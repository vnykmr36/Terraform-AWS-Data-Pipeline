environment = {
  name   = "prod"
  region = "us-west-2"
}

vpc_config = {
  vpc_cidr = "10.1.0.0/16"
}

ec2_config = {
  instance_type = "t3.micro"
  volume_size   = 10
  volume_type   = "gp2"
}

rds_config = {
  instance_class    = "db.t3.medium"
  engine            = "postgres"
  engine_version    = "16.3"
  allocated_storage = 50
}

common_tags = [{
  Environment = "prod"
  Terraform   = "true"
}]

key_admin = {
  admin = "<Key Admin>"
  user  = "Key user"
}

dms_details = {
  ri_version     = "3.5.4"
  instance_class = "dms.t3.small"
}