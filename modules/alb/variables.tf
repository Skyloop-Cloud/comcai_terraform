# ALB Modülü Değişkenleri

variable "project_name" {
  description = "Proje adı"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public Subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private Subnet IDs (private ALB için)"
  type        = list(string)
  default     = []
}

variable "alb_is_internal" {
  description = "ALB internal olsun mu (Cloudflare Tunnels için)"
  type        = bool
  default     = false
}

variable "enable_https" {
  description = "HTTPS desteği etkinleştir"
  type        = bool
  default     = true
}

variable "ssl_certificate_arn" {
  description = "SSL sertifikası ARN"
  type        = string
  default     = ""
}

