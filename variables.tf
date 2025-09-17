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

# Ek servisler için değişkenler
variable "enable_qdrant" {
  description = "Qdrant vector database'i etkinleştir"
  type        = bool
  default     = false
}

variable "enable_whisper" {
  description = "Whisper speech-to-text servisini etkinleştir"
  type        = bool
  default     = false
}

variable "use_groq" {
  description = "GROQ SaaS endpoint'lerini kullan"
  type        = bool
  default     = false
}

variable "alb_is_internal" {
  description = "ALB'yi private yap (Cloudflare Tunnels için)"
  type        = bool
  default     = false
}

variable "enable_https" {
  description = "HTTPS/TLS desteğini etkinleştir"
  type        = bool
  default     = true
}

variable "ssl_certificate_arn" {
  description = "SSL sertifikası ARN (ACM'den)"
  type        = string
  default     = ""
}

variable "restrict_to_cloudflare" {
  description = "Trafiği sadece Cloudflare IP'leriyle kısıtla"
  type        = bool
  default     = false
}

variable "cloudflare_ipv4_cidrs" {
  description = "Cloudflare IPv4 CIDR blokları"
  type        = list(string)
  default = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22"
  ]
}

