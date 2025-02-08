data "aws_caller_identity" "current" {}

data "aws_ami" "amzn_linx_latest" {
  owners           = ["amazon"]
  executable_users = ["all"]
  most_recent      = true
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "bastion-${var.environment.region}"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "db_client_instance" {
  ami           = data.aws_ami.amzn_linx_latest.id
  instance_type = var.ec2_config.instance_type
  tags = merge(var.tags, {
    Name = "ec2-tfm-${var.environment.name}-dbclient"
  })
  iam_instance_profile = "AWSSupportPatchwork-SSMRoleForInstances"
  key_name             = aws_key_pair.ec2_key_pair.key_name
  subnet_id            = var.subnet_id
  root_block_device {
    volume_size = var.ec2_config.volume_size
    volume_type = var.ec2_config.volume_type
  }
  ebs_block_device {
    encrypted   = true
    volume_size = var.ec2_config.volume_size * 2
    volume_type = var.ec2_config.volume_type
    kms_key_id  = var.kms_key_id
    device_name = "/dev/xvdb"
  }
  vpc_security_group_ids = [var.security_group_id]
  user_data              = <<-EOF
  sudo dnf update -y
  sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
  sudo dnf -qy module disable postgresql
  sudo dnf install -y postgresql15
  sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  sudo systemctl enable amazon-ssm-agent
  sudo systemctl restart amazon-ssm-agent
  EOF
}