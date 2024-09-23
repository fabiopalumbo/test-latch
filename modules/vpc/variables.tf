# variables

variable "region" {
  type        = string
  description = "Region to where the resources will be deployed"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

