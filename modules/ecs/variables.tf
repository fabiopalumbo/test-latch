# variables

variable "region" {
  type        = string
  description = "Region to where the resources will be deployed"
}

variable "docker_name" {
  type        = string
  description = "Docker image name"
}

variable "ecs_cluster" {
  type        = string
  description = "ECS Cluster name"
}

variable "ecs_capacity_provider" {
  type        = string
  description = "ECS Capacity Provider name"
}

variable "task_definition_name" {
  type        = string
  description = "Task definition name"
}

variable "image_uri" {
  type        = string
  description = "Image uri for Task Definition"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}
  