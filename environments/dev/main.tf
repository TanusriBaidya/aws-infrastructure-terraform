# =============================================================================
# environments/dev/main.tf
# Wires VPC, IAM, and EC2 modules together for the dev environment
# =============================================================================

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

 backend "s3" {
  bucket         = "tanusri-tfstate-dev"
  key            = "dev/terraform.tfstate"
  region         = "ap-southeast-2"    # ← change this
  use_lockfile = true 
  encrypt        = true
 }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

# -----------------------------------------------------------------------------
# Locals — single source of truth for shared values
# -----------------------------------------------------------------------------
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Tanusri Baidya"
    Repository  = "github.com/TanusriBaidya/aws-terraform"
  }
}

# -----------------------------------------------------------------------------
# VPC Module
# -----------------------------------------------------------------------------
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
}

# -----------------------------------------------------------------------------
# IAM Module
# -----------------------------------------------------------------------------
module "iam" {
  source = "../../modules/iam"

  project_name       = var.project_name
  environment        = var.environment
  s3_bucket_name     = var.app_s3_bucket_name
  create_deploy_user = var.create_deploy_user
  state_bucket_name  = "tanusri-tfstate-dev"
  lock_table_name    = "tanusri-tfstate-lock"
  tags               = local.common_tags
}

# -----------------------------------------------------------------------------
# EC2 Module
# -----------------------------------------------------------------------------
module "ec2" {
  source = "../../modules/ec2"

  subnet_id            = module.vpc.public_subnet_id
  vpc_id               = module.vpc.vpc_id
  instance_type        = var.instance_type
  ami_id               = var.ami_id
  iam_instance_profile = module.iam.ec2_instance_profile_name
}