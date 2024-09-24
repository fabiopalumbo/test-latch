# variables

variable "region" {
  type        = string
  description = "Region to where the resources will be deployed"
}

variable "s3_name" {
  type        = string
  description = "S3 Bucket name"
}
