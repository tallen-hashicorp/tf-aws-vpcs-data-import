provider "aws" {
  region = "us-east-1"
}

data "aws_vpcs" "all_vpcs" {
  tags = {
    service = "data-import-demo"
  }
}

locals {
  existing_vpcs = data.aws_vpcs.all_vpcs.ids
}
import {
  for_each = local.existing_vpcs

  to = aws_vpc.starter_vpc[each.value]
  id = "${each.value}"
}


resource "aws_vpc" "starter_vpc" {
  for_each = toset(local.existing_vpcs)
  cidr_block = "10.0.0.0/16"
  tags = {
    service = "data-import-demo"
  }
}
