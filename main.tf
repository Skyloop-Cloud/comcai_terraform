# Comcai Tam Mimari - Güvenlik Tag'li
# Modern web uygulaması için tam altyapı

# VPC Modülü
module "vpc" {
  source = "./modules/vpc"
  
  project_name            = var.project_name
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  availability_zones     = var.availability_zones
  environment            = var.environment
  restrict_to_cloudflare = var.restrict_to_cloudflare
  cloudflare_ipv4_cidrs  = var.cloudflare_ipv4_cidrs
}

# S3 Modülü
module "s3" {
  source = "./modules/s3"
  
  project_name = var.project_name
  environment  = var.environment
}

# ECR Modülü
module "ecr" {
  source = "./modules/ecr"
  
  project_name = var.project_name
  environment  = var.environment
}

# ElastiCache Redis Modülü
module "elasticache" {
  source = "./modules/elasticache"
  
  project_name        = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.elasticache_sg_id]
  environment        = var.environment
}

# ALB Modülü
module "alb" {
  source = "./modules/alb"
  
  project_name         = var.project_name
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
  security_group_id   = module.vpc.alb_sg_id
  environment         = var.environment
  alb_is_internal     = var.alb_is_internal
  enable_https        = var.enable_https
  ssl_certificate_arn = var.ssl_certificate_arn
}

# ECS Modülü
module "ecs" {
  source = "./modules/ecs"
  
  project_name           = var.project_name
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  security_group_ids    = [module.vpc.ecs_sg_id]
  target_group_arn      = module.alb.target_group_arn
  ecr_repository_url    = module.ecr.repository_url
  s3_bucket_name        = module.s3.bucket_name
  redis_endpoint        = module.elasticache.redis_endpoint
  environment           = var.environment
  enable_qdrant         = var.enable_qdrant
  enable_whisper        = var.enable_whisper
  use_groq              = var.use_groq
}

# API Gateway Modülü
module "api_gateway" {
  source = "./modules/api_gateway"
  
  project_name = var.project_name
  environment  = var.environment
  alb_dns_name = module.alb.alb_dns_name
}