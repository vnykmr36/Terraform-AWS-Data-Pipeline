[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fvnykmr36%2FTerraform-AWS-Data-Pipeline&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
# Data lake setup within AWS

Within this code package, we launch a multitude of services where an entire data pipeline is laid after we provision required infrastructure.

## List of services launched:

- VPC(Public and Private Subnets, Route tables, NACLs and Security Group and VPC endpoints)
- IAM(Policy and Roles)
- EC2
- RDS(Subnet group, Parameter group and RDS Instance)
- S3
- DMS(Subnet group, Replication Instance, Endpoints and Task)

Data pipeline is set for full data migration along with change data replication on to S3 data lake in Parquet format for data processing by downstream.

## Configration changes:

Before proceeding with resource launch, following details need to be changed for successful deployments 

Bucket name: tfm_aws_deploy/modules/S3/main.tf

Backend Bucket details in
- tfm_aws_deploy/backend-setup/dev.tfbackend
- tfm_aws_deploy/backend-setup/qa.tfbackend
- tfm_aws_deploy/backend-setup/prod.tfbackend

IAM roles expected for admin and user roles in key_admin variable where existing IAM roles to be provided
- tfm_aws_deploy/environment/dev.tfvars
- tfm_aws_deploy/environment/qa.tfvars
- tfm_aws_deploy/environment/prod.tfvars

## Deploy Instructions
```
$ export environment="dev"
$ terraform init -var-file=environment/$environment.tfvars -backend-config=backend-setup/$environment.tfbackend -backend=true
$ terraform plan -var-file=environment/$environment.tfvars  
$ terraform apply -var-file=environment/$environment.tfvars 
```
## Delete Instruction
```
$ terraform destroy -var-file=environment/$environment.tfvars
```
