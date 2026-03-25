# Variables - reusable values (like environment variables)

variable "aws_region" {
  description = "AWS region to deploy to"
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of the application"
  default     = "devops-starter"
}

variable "container_port" {
  description = "Port the container listens on"
  default     = 3000
}

variable "aws_account_id" {
  description = "Your AWS Account ID"
  default     = "363191779124"
}
