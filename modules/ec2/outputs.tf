output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2.id
}