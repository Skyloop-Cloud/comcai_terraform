# API Gateway Modülü Değişkenleri

variable "project_name" {
  description = "Proje adı"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS Name"
  type        = string
}
