provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

resource "aws_vpc" "Demo-VPC" {
  cidr_block = var.cidr
}

resource "aws_internet_gateway" "Demo-IGW" {
  vpc_id = aws_vpc.Demo-VPC.id
}

resource "aws_route" "Demo-route" {
  route_table_id         = aws_vpc.Demo-VPC.main_route_table_id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.Demo-IGW.id
}
data "aws_availability_zones" "available" {}

resource "aws_subnet" "main" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.Demo-VPC.id
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
}