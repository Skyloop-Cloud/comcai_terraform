# ALB Modülü - Application Load Balancer

# ALB oluştur
resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = var.alb_is_internal
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.alb_is_internal ? var.private_subnet_ids : var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = var.environment
    Type        = var.alb_is_internal ? "internal" : "internet-facing"
    "berkay-test" = "true"
  }
}

# Target Group oluştur
resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-tg-ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = {
    Name        = "${var.project_name}-tg-ip"
    Environment = var.environment
    "berkay-test" = "true"
  }
}

# HTTP ALB Listener (HTTPS etkinse redirect eder)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = var.enable_https ? "redirect" : "forward"
    
    dynamic "redirect" {
      for_each = var.enable_https ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    
    dynamic "forward" {
      for_each = var.enable_https ? [] : [1]
      content {
        target_group {
          arn = aws_lb_target_group.main.arn
        }
      }
    }
  }

  tags = {
    Name        = "${var.project_name}-http-listener"
    Environment = var.environment
    "berkay-test" = "true"
  }
}

# HTTPS ALB Listener (opsiyonel)
resource "aws_lb_listener" "https" {
  count = var.enable_https && var.ssl_certificate_arn != "" ? 1 : 0
  
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = {
    Name        = "${var.project_name}-https-listener"
    Environment = var.environment
    "berkay-test" = "true"
  }
}

