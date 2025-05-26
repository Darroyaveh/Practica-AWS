variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "sa-east-1"
}

variable "instance_count" {
  description = "The number of EC2 instances to create."
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "The type of EC2 instances to create (e.g., t2.micro, m5.large)."
  type        = string
  default     = "t2.micro"
}

variable "instance_name_prefix" {
  description = "A prefix for naming the EC2 instances."
  type        = string
  default     = "homework-instance"
}

variable "rdp_source_ip" {
  description = "The source IP address range allowed for RDP access. For specific IP use 'your_ip/32'."
  type        = string
  default     = "0.0.0.0/0" # Be cautious with this default in production
}
