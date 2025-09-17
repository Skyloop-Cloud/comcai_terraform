# ECS Modülü - Elastic Container Service

# ECS Cluster oluştur
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.project_name}-cluster"
    Environment = var.environment
    "berkay-test" = "true"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.enable_qdrant || var.enable_whisper ? "1024" : "256"
  memory                   = var.enable_qdrant || var.enable_whisper ? "2048" : "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn           = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode(concat(
    [
      # Ana uygulama container'ı
      {
        name  = "${var.project_name}-container"
        image = "${var.ecr_repository_url}:latest"
        
        portMappings = [
          {
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
          }
        ]

        environment = concat([
          {
            name  = "S3_BUCKET"
            value = var.s3_bucket_name
          },
          {
            name  = "ENVIRONMENT"
            value = var.environment
          },
          {
            name  = "USE_GROQ"
            value = tostring(var.use_groq)
          }
        ], var.use_groq ? [] : [
          {
            name  = "REDIS_ENDPOINT"
            value = var.redis_endpoint
          }
        ], var.enable_qdrant ? [
          {
            name  = "QDRANT_ENDPOINT"
            value = "http://localhost:6333"
          }
        ] : [], var.enable_whisper ? [
          {
            name  = "WHISPER_ENDPOINT"
            value = "http://localhost:9000"
          }
        ] : [])

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.main.name
            awslogs-region        = "eu-central-1"
            awslogs-stream-prefix = "app"
          }
        }

        essential = true
      }
    ],
    # Qdrant container (opsiyonel)
    var.enable_qdrant ? [
      {
        name  = "${var.project_name}-qdrant"
        image = "qdrant/qdrant:latest"
        
        portMappings = [
          {
            containerPort = 6333
            hostPort      = 6333
            protocol      = "tcp"
          }
        ]

        environment = [
          {
            name  = "QDRANT__SERVICE__HOST"
            value = "0.0.0.0"
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.main.name
            awslogs-region        = "eu-central-1"
            awslogs-stream-prefix = "qdrant"
          }
        }

        essential = false
      }
    ] : [],
    # Whisper container (opsiyonel)
    var.enable_whisper ? [
      {
        name  = "${var.project_name}-whisper"
        image = "onerahmet/openai-whisper-asr-webservice:latest"
        
        portMappings = [
          {
            containerPort = 9000
            hostPort      = 9000
            protocol      = "tcp"
          }
        ]

        environment = [
          {
            name  = "ASR_MODEL"
            value = "base"
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.main.name
            awslogs-region        = "eu-central-1"
            awslogs-stream-prefix = "whisper"
          }
        }

        essential = false
      }
    ] : []
  ))

  tags = {
    Name        = "${var.project_name}-task"
    Environment = var.environment
    "berkay-test" = "true"
  }
}

# ECS Service
resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.project_name}-container"
    container_port   = 80
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_execution_role_policy]

  tags = {
    Name        = "${var.project_name}-service"
    Environment = var.environment
    "berkay-test" = "true"
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-logs"
    Environment = var.environment
    "berkay-test" = "true"
  }
}

# ECS Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-ecs-execution-role"
    Environment = var.environment
    "berkay-test" = "true"
  }
}

# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-ecs-task-role"
    Environment = var.environment
    "berkay-test" = "true"
  }
}

# ECS Execution Role Policy Attachment
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Role Policy - S3 Access
resource "aws_iam_role_policy" "ecs_task_s3_policy" {
  name = "${var.project_name}-ecs-task-s3-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

