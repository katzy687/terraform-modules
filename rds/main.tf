terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">3.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  id = var.vpc_id
}

locals {
  sizeMap = {
    "small"  = "db.t2.small"
    "medium" = "db.t2.medium"
    "large"  = "db.t2.large"
  }
  instance_class = lookup(local.sizeMap, lower(var.size), "db.t4g.medium")
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "aws_db_subnet_group" "rds" {
  name       = "rds-${var.sandbox_id}-subnet-group"
  subnet_ids = split(",", var.subnets) 

  tags = {
    Name = "RDS-subnet-group"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage         = var.allocated_storage
  storage_type              = var.storage_type
  engine                    = var.engine
  engine_version            = var.engine_version
  instance_class            = local.instance_class
  identifier                = "rds-${var.sandbox_id}"
  name                      = var.db_name
  username                  = var.username
  password                  = random_password.password.result
  publicly_accessible       = true
  db_subnet_group_name      = aws_db_subnet_group.rds.id
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
}
