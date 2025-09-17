# ElastiCache Modülü Değişkenleri

variable "project_name" {
  description = "Proje adı"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private Subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Group IDs"
  type        = list(string)
}

variable "environment" {
  description = "Environment"
  type        = string
}

