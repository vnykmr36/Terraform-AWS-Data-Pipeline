data "aws_availability_zones" "available" {
  state = "available"
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  az_count = length(data.aws_availability_zones.available.names)
  sgrules  = [var.vpc_config.vpc_cidr, "${chomp(data.http.myip.response_body)}/32"]
}

resource "aws_vpc" "tfm_vpc" {
  cidr_block           = var.vpc_config.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, {
    Name = "vpc-tfm-${var.environment.name}"
  })
}

resource "aws_internet_gateway" "int_gtwy" {
  vpc_id = aws_vpc.tfm_vpc.id
  tags = merge(var.tags, {
    Name = "igw-tfm-${var.environment.name}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "def_vpc_sg_rules" {
  count             = 2
  security_group_id = aws_vpc.tfm_vpc.default_security_group_id
  cidr_ipv4         = local.sgrules[count.index]
  ip_protocol       = -1
}

resource "aws_subnet" "privatesubs" {
  count             = local.az_count
  vpc_id            = aws_vpc.tfm_vpc.id
  cidr_block        = cidrsubnet(var.vpc_config.vpc_cidr, 3, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(var.tags, {
    Name = "subnet-tfm-${var.environment.name}-private-${count.index}"
  })
}

resource "aws_subnet" "publicsubs" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.tfm_vpc.id
  cidr_block              = cidrsubnet(var.vpc_config.vpc_cidr, 3, count.index + local.az_count)
  depends_on              = [aws_internet_gateway.int_gtwy]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "subnet-tfm-${var.environment.name}-public-${count.index}"
  })
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = merge(var.tags, {
    Name = "eip-tfm-${var.environment.name}"
  })
}

resource "aws_nat_gateway" "nat_gtwy" {
  subnet_id     = aws_subnet.publicsubs[0].id
  allocation_id = aws_eip.nat_eip.id
  depends_on    = [aws_internet_gateway.int_gtwy]
  tags = merge(var.tags, {
    Name = "nat-tfm-${var.environment.name}"
  })
}

resource "aws_route" "public_route" {
  route_table_id         = aws_vpc.tfm_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.int_gtwy.id
  depends_on = [aws_internet_gateway.int_gtwy]
}

resource "aws_route_table_association" "public_rtb_associate" {
  count          = length(aws_subnet.publicsubs)
  subnet_id      = aws_subnet.publicsubs[count.index].id
  route_table_id = aws_vpc.tfm_vpc.default_route_table_id
}

resource "aws_route_table" "priv_rtb" {
  vpc_id = aws_vpc.tfm_vpc.id
  tags = merge(var.tags, {
    Name = "rtb-tfm-${var.environment.name}-private"
  })
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.priv_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gtwy.id
  depends_on             = [aws_route_table.priv_rtb, aws_nat_gateway.nat_gtwy]
}

resource "aws_route_table_association" "private_rtb_associate" {
  count          = length(aws_subnet.privatesubs)
  subnet_id      = aws_subnet.privatesubs[count.index].id
  route_table_id = aws_route_table.priv_rtb.id
}

resource "aws_network_acl_association" "public_subnet_acl" {
  count          = length(aws_subnet.publicsubs)
  subnet_id      = aws_subnet.publicsubs[count.index].id
  network_acl_id = aws_vpc.tfm_vpc.default_network_acl_id
}

resource "aws_network_acl_association" "private_subnet_acl" {
  count          = length(aws_subnet.privatesubs)
  subnet_id      = aws_subnet.privatesubs[count.index].id
  network_acl_id = aws_vpc.tfm_vpc.default_network_acl_id
}

resource "aws_vpc_endpoint" "s3endpoint" {
  vpc_id            = aws_vpc.tfm_vpc.id
  service_name      = "com.amazonaws.${var.environment.region}.s3"
  tags              = var.tags
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_vpc.tfm_vpc.default_route_table_id, aws_route_table.priv_rtb.id]
}

resource "aws_vpc_endpoint" "secretsendpoint" {
  vpc_id            = aws_vpc.tfm_vpc.id
  service_name      = "com.amazonaws.${var.environment.region}.secretsmanager"
  tags              = var.tags
  vpc_endpoint_type = "Interface"
  ip_address_type = "ipv4"
  private_dns_enabled = true
  service_region = null
  security_group_ids = [aws_vpc.tfm_vpc.default_security_group_id]
}

resource "aws_vpc_endpoint_subnet_association" "subnetsaddsecret" {
  count = length(aws_subnet.privatesubs)
  vpc_endpoint_id = aws_vpc_endpoint.secretsendpoint.id
  subnet_id = aws_subnet.privatesubs[count.index].id 
}
