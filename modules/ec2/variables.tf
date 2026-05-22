variable "subnet_id" {
  type        = string
  description = "Subnet ID where EC2 will be placed"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for security group"
}
variable "iam_instance_profile" {
  description = "IAM instance profile name to attach to the EC2 instance"
  type        = string
  default     = null
}