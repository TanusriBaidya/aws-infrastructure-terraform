variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Project identifier used in resource names and tags"
  type        = string
  default     = "tanusri-aws-tf"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (Amazon Linux 2023 in ap-southeast-2)"
  type        = string
  default     = "ami-0310483fb2b488153"
}

variable "app_s3_bucket_name" {
  description = "S3 bucket the EC2 instance role is scoped to access"
  type        = string
  default     = "tanusri-app-assets-dev"
}

variable "create_deploy_user" {
  description = "Set to true to create a CI/CD IAM user for GitHub Actions"
  type        = bool
  default     = false
}