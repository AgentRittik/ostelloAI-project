
module "nestjs_app_repository" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name                 = var.ecr_repository_name
  repository_type                 = "private"
  repository_image_tag_mutability = "IMMUTABLE"
  create_lifecycle_policy         = true

  # only keep the latest 5 images
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images by count"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = merge(var.common_tags)
}

resource "aws_ecs_cluster" "nestjs_app_cluster" {
  name = var.ecs_cluster_name
  tags = var.common_tags
}

resource "aws_ecs_task_definition" "nestjs_app_runner" {
  family                   = var.ecs_task_definition_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name   = var.ecs_container_name
      image  = "${module.nestjs_app_repository.repository_url}:latest"
      cpu    = 512
      memory = 1024
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      essential = true
    }
  ])
  tags = var.common_tags
}

resource "aws_ecs_service" "nestjs_app_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.nestjs_app_cluster.id
  task_definition = aws_ecs_task_definition.nestjs_app_runner.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [element(module.nestjs_app_vpc.public_subnets, 0)]
    security_groups  = [module.web_access_sg.security_group_id]
    assign_public_ip = true
  }

  tags = var.common_tags
}
