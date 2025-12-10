########################################
# ECS Cluster
########################################

module "ecs_cluster" {
  source = "./modules/ecs/cluster"

  name   = "my-cluster"
  region = var.region

  # Essentials only
  create_cloudwatch_log_group = true
  cloudwatch_log_group_name   = "/ecs/my-backend"

  tags = var.tags
}

########################################
# ECS Service (Backend API)
########################################

module "ecs_service_backend" {
  source = "./modules/ecs/service"

  create         = true
  create_service = true
  region         = var.region

  name        = "backend-api"
  cluster_arn = module.ecs_cluster.arn

  # -----------------------------------
  # Launch Type (Use FARGATE – simple)
  # -----------------------------------
  launch_type = "FARGATE"
  desired_count = 1

load_balancer = {
  backend = {
    container_name = "backend-api"
    container_port   = 3000
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}


  # -----------------------------------
  # Networking
  # -----------------------------------
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.ecs_sg.id]
  assign_public_ip   = false

  


  # -----------------------------------
  # Task Definition
  # -----------------------------------
  create_task_definition = true
  family                 = "backend-api-task"

  cpu    = 256
  memory = 512

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = {
  backend_api = {
    name      = "backend-api"
    image     = "${var.ecr_repo_url}:latest"
    essential = true
      environment = [
  { name = "DB_HOST", value = var.DB_HOST },
  { name = "DB_USER", value = var.DB_USER},
  { name = "DB_PASS", value = var.DB_PASS},
  { name = "DB_NAME", value = "mydb" },
  { name = "DB_PORT", value = "3306" }
]

    portMappings = [
      {
        containerPort = 3000
        hostPort      = 3000
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/my-backend"
        awslogs-region        = var.region
        awslogs-stream-prefix = "ecs"
      }
    }
  }
}

  # -----------------------------------
  # No capacity providers (KEPT CLEAN)
  # -----------------------------------
  capacity_provider_strategy = null

  tags = var.tags
}
