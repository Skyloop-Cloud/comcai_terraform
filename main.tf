# Comcai Tam Mimari - Güvenlik Tag'li
# Modern web uygulaması için tam altyapı

# VPC Modülü
module "vpc" {
  source = "./modules/vpc"
  
  project_name         = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
  environment         = var.environment
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
  
  project_name      = var.project_name
  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.private_subnet_ids
  security_group_id = module.vpc.alb_sg_id
  environment       = var.environment
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
}

# API Gateway Modülü
module "api_gateway" {
  source = "./modules/api_gateway"
  
  project_name = var.project_name
  environment  = var.environment
  alb_dns_name = module.alb.alb_dns_name
}

# IAM Modülü (GitHub Actions için)
module "iam" {
  source = "./modules/iam"
  
  project_name           = var.project_name
  environment            = var.environment
  ecs_execution_role_arn = module.ecs.execution_role_arn
  ecs_task_role_arn      = module.ecs.task_role_arn
}