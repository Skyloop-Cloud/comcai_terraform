# ElastiCache Modülü - Redis Cluster

# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-cache-subnet"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.project_name}-cache-subnet"
    Environment = var.environment
    "berkay-test" = "true"
  }
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "main" {
  family = "redis7"
  name   = "${var.project_name}-redis-params"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }

  tags = {
    Name        = "${var.project_name}-redis-params"
    Environment = var.environment
    "berkay-test" = "true"
  }
}

# ElastiCache Redis Cluster
resource "aws_elasticache_replication_group" "main" {
  replication_group_id         = "${var.project_name}-redis"
  description                  = "Redis cluster for ${var.project_name}"
  
  node_type                    = "cache.t3.micro"
  port                         = 6379
  parameter_group_name         = aws_elasticache_parameter_group.main.name
  subnet_group_name           = aws_elasticache_subnet_group.main.name
  security_group_ids          = var.security_group_ids
  
  num_cache_clusters          = 2
  automatic_failover_enabled  = true
  multi_az_enabled           = true
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  
  maintenance_window         = "sun:05:00-sun:06:00"
  snapshot_retention_limit   = 5
  snapshot_window           = "03:00-05:00"

  tags = {
    Name        = "${var.project_name}-redis"
    Environment = var.environment
    "berkay-test" = "true"
  }
}
