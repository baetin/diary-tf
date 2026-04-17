# variables.tf
variable "aws_region" { default = "ap-northeast-2" }
variable "domain_name" { default = "taebin.shop" }
variable "s3_bucket_name" { default = "taebin-diary-photos-unique-id" }
variable "ami_id" { default = "ami-0c003e98ceffee43e" }