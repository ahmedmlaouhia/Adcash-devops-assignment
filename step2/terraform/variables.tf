variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-west-3"
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "dev"
}

variable "extra_tags" {
  description = "Additional tags merged onto every AWS resource"
  type        = map(string)
  default     = {}
}

variable "key_pair_name" {
  description = "EC2 key pair name to create"
  type        = string
}

variable "public_key_path" {
  description = "Filesystem path to the public SSH key (PEM format)"
  type        = string
}

variable "resource_name_prefix" {
  description = "Prefix applied to key AWS resources"
  type        = string
  default     = "gandalf"
}

variable "vpc_id" {
  description = "ID of the VPC where the instance will be provisioned"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID inside the target VPC"
  type        = string
}

variable "ssh_allowed_cidrs" {
  description = "CIDR blocks allowed to access the instance via SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_allowed_cidrs" {
  description = "CIDR blocks allowed to reach the instance over HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ami_id" {
  description = "Amazon Machine Image ID for the VM"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = true
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring on the instance"
  type        = bool
  default     = false
}

variable "root_volume_size_gb" {
  description = "Size of the root EBS volume in GiB"
  type        = number
  default     = 20
}
