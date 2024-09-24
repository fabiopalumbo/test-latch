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

module "ecs_service_1" {
  source                = "./modules/ecs"
  ecs_cluster           = "my-cluster"
  ecs_capacity_provider = "my-capacity-provider"
  image_uri             = "my-image-service_1"
  task_definition_name  = "my-task-service_1"
  docker_name           = "my-docker-service_1"
  region                = "us-east-1"
}

module "ecs_service_2" {
  source                = "./modules/ecs"
  ecs_cluster           = "my-cluster"
  ecs_capacity_provider = "my-capacity-provider"
  image_uri             = "my-image-service_2"
  task_definition_name  = "my-task-service_2"
  docker_name           = "my-docker-service_2"
  region                = "us-east-1"
}

module "ecs_service_3" {
  source                = "./modules/ecs"
  ecs_cluster           = "my-cluster"
  ecs_capacity_provider = "my-capacity-provider"
  image_uri             = "my-image-service_3"
  task_definition_name  = "my-task-service_3"
  docker_name           = "my-docker-service_3"
  region                = "us-east-1"
}