variable "project_name" {
  description = "Project name prefix for all IAM resource names"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket the EC2 role is scoped to access"
  type        = string
}

variable "create_deploy_user" {
  description = "Set true to create a CI/CD IAM user for GitHub Actions"
  type        = bool
  default     = false
}

variable "state_bucket_name" {
  description = "S3 bucket holding Terraform remote state"
  type        = string
  default     = ""
}

variable "lock_table_name" {
  description = "DynamoDB table for Terraform state locking"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to all IAM resources"
  type        = map(string)
  default     = {}
}