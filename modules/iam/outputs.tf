output "ec2_role_arn" {
  description = "ARN of the IAM role assigned to EC2 instances"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.ec2_role.name
}

output "ec2_instance_profile_name" {
  description = "Instance profile name — pass this to the EC2 module"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "ec2_instance_profile_arn" {
  description = "ARN of the instance profile"
  value       = aws_iam_instance_profile.ec2_profile.arn
}

output "deploy_user_access_key_id" {
  description = "Access key ID for the CI/CD deploy user"
  value       = var.create_deploy_user ? aws_iam_access_key.deploy_user_key[0].id : ""
  sensitive   = true
}

output "deploy_user_secret_access_key" {
  description = "Secret key for the CI/CD deploy user — store in GitHub Secrets"
  value       = var.create_deploy_user ? aws_iam_access_key.deploy_user_key[0].secret : ""
  sensitive   = true
}