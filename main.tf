# main.tf

terraform {
  backend "local" {}
}


module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  region   = "us-east-1"
}

module "cloudfront" {
  source  = "./modules/cloudfront"
  region  = "us-east-1"
  s3_name = "my-bucket"
}

module "rds" {
  source    = "./modules/rds"
  db_engine = "mysql"
  db_name   = "my-db"
  region    = "us-east-1"
}

module "ecs_inventory" {
  source                = "./modules/ecs"
  ecs_cluster           = "my-cluster"
  ecs_capacity_provider = "my-capacity-provider"
  image_uri             = "my-image-inventory"
  task_definition_name  = "my-task-inventory"
  docker_name           = "my-docker-inventory"
  region                = "us-east-1"
}

module "ecs_accounting" {
  source                = "./modules/ecs"
  ecs_cluster           = "my-cluster"
  ecs_capacity_provider = "my-capacity-provider"
  image_uri             = "my-image-accounting"
  task_definition_name  = "my-task-accounting"
  docker_name           = "my-docker-accounting"
  region                = "us-east-1"
}

module "ecs_shipping" {
  source                = "./modules/ecs"
  ecs_cluster           = "my-cluster"
  ecs_capacity_provider = "my-capacity-provider"
  image_uri             = "my-image-shipping"
  task_definition_name  = "my-task-shipping"
  docker_name           = "my-docker-shipping"
  region                = "us-east-1"
}