resource "aws_ecs_task_definition" "default" {
  family = "${var.cluster_name}-${var.name}"

  execution_role_arn = var.task_role_arn
  task_role_arn      = var.task_role_arn

  requires_compatibilities = [var.launch_type]

  network_mode = var.launch_type == "FARGATE" ? "awsvpc" : var.network_mode
  cpu          = var.launch_type == "FARGATE" ? var.cpu : null
  memory       = var.launch_type == "FARGATE" ? var.memory : null

  container_definitions = <<EOT
[
  {
    "name": "${var.name}",
    "image": "${var.image}",
    "cpu": ${var.cpu},
    "memory": ${var.memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.container_port}
      }
    ],
    "log_configuration": {
      "log_driver": "awslogs",
      "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.default.arn}",
          "awslogs-region": "ap-southeast-2",
          "awslogs-stream-prefix": "app"
      }
    }
  }
]
EOT
}