variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  default     = "us-east-1" 
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t3.medium"
}

variable "my_enviroment" {
  description = "Environment name"
  default     = "dev"
}

# Optional: Add a variable for your project name to keep things clean
variable "project_name" {
  description = "Name of the project"
  default     = "tws-e-commerce"
}