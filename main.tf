provider "aws" {
  region = "us-east-1"
}

data "aws_vpcs" "all_vpcs" {
  tags = {
    service = "data-import-demo"
  }
}

locals {
    existing_vpc_ids = toset(data.aws_vpcs.all_vpcs.ids)
    new_vpc_needed   = setsubtract(toset(["create"]), local.existing_vpc_ids)
}

import {
  for_each = local.existing_vpc_ids

  to = aws_vpc.starter_vpc[each.value]
  id = "${each.value}"
}


resource "aws_vpc" "starter_vpc" {
  for_each = local.new_vpc_needed
  cidr_block = "10.0.0.0/16"
  tags = {
    service = "data-import-demo"
  }
}
