terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.62"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.environment["region"]
}

module "kms" {
  source    = "./modules/KMS"
  tags      = var.common_tags
  key_admin = var.key_admin
}

module "vpc" {
  source      = "./modules/VPC"
  tags        = var.common_tags
  vpc_config  = var.vpc_config
  environment = var.environment
}

module "rds" {
  source            = "./modules/RDS"
  tags              = var.common_tags
  rds_config        = var.rds_config
  depends_on        = [module.vpc, module.kms]
  kmskey            = module.kms.key_arn
  vpc_id            = module.vpc.vpc_id
  privatesubnets    = module.vpc.private_subnet_ids
  security_group_id = [module.vpc.security_group_id]
}

module "ec2" {
  source            = "./modules/EC2"
  tags              = var.common_tags
  vpc_config        = var.vpc_config
  ec2_config        = var.ec2_config
  kms_key_id        = module.kms.key_id
  subnet_id         = module.vpc.public_subnet_ids[0]
  depends_on        = [module.vpc, module.kms]
  environment       = var.environment
  security_group_id = module.vpc.security_group_id
}
module "iam" {
  source     = "./modules/IAM"
  tags       = var.common_tags
  depends_on = [module.rds, module.kms]
  kmskey     = module.kms.key_arn
  environment       = var.environment
}
module "s3" {
  source     = "./modules/S3"
  tags       = var.common_tags
  rds_config = var.rds_config
}

module "dms" {
  source            = "./modules/DMS"
  depends_on        = [module.vpc]
  tags              = var.common_tags
  rds_config        = var.rds_config
  kms_key_id        = module.kms.key_id
  environment       = var.environment
  rds_secret_arn    = module.rds.rds_secret_arn
  iam_role_arn      = module.iam.iam_role_arn
  dms_details       = var.dms_details
  rds_dbname        = module.rds.rds_dbname
  security_group_id = [module.vpc.security_group_id]
  vpc_id            = module.vpc.vpc_id
  privatesubnets    = module.vpc.private_subnet_ids
  bucket            = module.s3.s3res_name
  rds_endpoint      = module.rds.rds_endpoint
  rds_user          = module.rds.rds_user
}
