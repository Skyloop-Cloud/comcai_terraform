# API Gateway Modülü Çıktıları

output "api_id" {
  description = "API Gateway ID"
  value       = aws_api_gateway_rest_api.main.id
}

output "api_arn" {
  description = "API Gateway ARN"
  value       = aws_api_gateway_rest_api.main.arn
}

output "api_url" {
  description = "API Gateway URL"
  value       = "https://${aws_api_gateway_rest_api.main.id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${aws_api_gateway_stage.main.stage_name}"
}

output "api_stage_name" {
  description = "API Gateway Stage Name"
  value       = aws_api_gateway_stage.main.stage_name
}

output "api_deployment_id" {
  description = "API Gateway Deployment ID"
  value       = aws_api_gateway_deployment.main.id
}

# Data source for current region
data "aws_region" "current" {}
