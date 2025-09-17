# Comcai Değişkenleri

variable "aws_region" {
  description = "AWS bölgesi"
  type        = string
  default     = "eu-central-1"  # Frankfurt
}

variable "project_name" {
  description = "Proje adı (tüm kaynaklarda kullanılacak)"
  type        = string
  default     = "comcai-berkay-test"
}

variable "vpc_cidr" {
  description = "VPC için IP aralığı"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blokları"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blokları"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "availability_zones" {
  description = "Availability zone'lar"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

