# variables

variable "region" {
  type        = string
  description = "Region to where the resources will be deployed"
}

variable "s3_name" {
  type        = string
  description = "S3 Bucket name"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "docker_inventory" {
  type        = string
  description = "Docker image for inventory"
}

variable "docker_accounting" {
  type        = string
  description = "Docker image for accounting"
}

variable "docker_shipping" {
  type        = string
  description = "Docker image for shipping"
}

variable "ecs_cluster" {
  type        = string
  description = "ECS Cluster name"
}

variable "ecs_capacity_provider" {
  type        = string
  description = "ECS Capacity Provider name"
}

variable "task_accounting" {
  type        = string
  description = "Task definition for accounting"
}

variable "task_inventory" {
  type        = string
  description = "Task definition for inventory"
}

variable "task_shipping" {
  type        = string
  description = "Task definition for shipping"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_engine" {
  type        = string
  description = "Database engine"
}

variable "image_accounting" {
  type        = string
  description = "Image for accounting"
}

variable "image_shipping" {
  type        = string
  description = "Image for shipping"
}

variable "image_inventory" {
  type        = string
  description = "Image for inventory"
}

