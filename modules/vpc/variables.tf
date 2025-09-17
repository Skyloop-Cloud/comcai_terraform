# VPC Modülü Değişkenleri

variable "project_name" {
  description = "Proje adı"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR bloğu"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blokları"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blokları"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zone'lar"
  type        = list(string)
}

variable "environment" {
  description = "Environment"
  type        = string
}


