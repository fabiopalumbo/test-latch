# variables

variable "region" {
  type        = string
  description = "Region to where the resources will be deployed"
}


variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_engine" {
  type        = string
  description = "Database engine"
}
