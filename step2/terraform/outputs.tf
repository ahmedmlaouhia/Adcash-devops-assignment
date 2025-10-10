output "instance_id" {
  description = "Id of Gandalf instance"
  value       = aws_instance.gandalf.id
}

output "instance_public_ip" {
  description = "Public IP of Gandalf instance"
  value       = aws_instance.gandalf.public_ip
}

output "security_group_id" {
  description = "Security group of Gandalf instance"
  value       = aws_security_group.gandalf.id
}
