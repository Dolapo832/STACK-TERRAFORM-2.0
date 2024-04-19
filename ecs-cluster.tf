## Creating the ECS Cluster ##
resource "aws_ecs_cluster" "Stack_cluster_Clixx" {
  name = "Clixx-ecs-cluster"
}

## Creating the IAM Role for ECS ##
resource "aws_iam_role" "ecsTaskExecutionRole2" {
  name               = "ecsTaskExecutionRole2"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action"    : "sts:AssumeRole",
        "Effect"    : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

## Attaching Policy to ECS Task Execution Role ##
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole2_attachment" {
  role       = aws_iam_role.ecsTaskExecutionRole2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

### Creating the Task Definition ###
resource "aws_ecs_task_definition" "Clixx_task" {
  family             = "Clixx-task"
  network_mode       = "awsvpc"
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole2.arn
  task_role_arn      = aws_iam_role.ecsTaskExecutionRole2.arn

  cpu               = 256
  memory            = 512

  container_definitions = jsonencode([
    {
      name      = "Clixx-Container"
      image     = "${data.aws_ecr_repository.ecr_repository.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

## Creating the Service Under Task Definition ##
resource "aws_ecs_service" "ecs_service" {
  name            = "stack-Clixx-services"
  cluster         = aws_ecs_cluster.Stack_cluster_Clixx.arn
  task_definition = aws_ecs_task_definition.Clixx_task.arn
  desired_count   = 2

  network_configuration {
    subnets          = [
      element(aws_subnet.private_subnets1.*.id, 0),
      element(aws_subnet.private_subnets2.*.id, 0)
    ]
    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_target_group.arn
    container_name   = "Clixx-Container"
    container_port   = 80
  }

  depends_on = [aws_autoscaling_group.app_asg]
}




# ## Creating the ECS Cluster ###
# resource "aws_ecs_cluster" "Stack_cluster_Clixx" {
#   name = "Clixx-ecs-cluster"
# }

# ## Creating the IAM Role for ECS ###
# resource "aws_iam_role" "ecsTaskExecutionRole2" {
#   name               = "ecsTaskExecutionRole2"
#   assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
# }

# ### Creating the Task Definition ###
# resource "aws_ecs_task_definition" "Clixx_task" {
#  family             = "Clixx-task"
#  network_mode       = "awsvpc"
#  execution_role_arn        = aws_iam_role.ecsTaskExecutionRole2.arn
#  task_role_arn             = aws_iam_role.ecsTaskExecutionRole2.arn
#  cpu                = 256
#  runtime_platform {
#    operating_system_family = "LINUX"
#    cpu_architecture        = "X86_64"
#  }
#  container_definitions = jsonencode([
#    {
#      name      = "Clixx-Container"
#      image = "${data.aws_ecr_repository.ecr_repository.repository_url}:latest"
#      cpu       = 256
#      memory    = 512
#      essential = true
#      portMappings = [
#        {
#          containerPort = 80
#          hostPort      = 80
#          protocol      = "tcp"
#        }
#      ]
#    }
#  ])
# }

# ## Creating the Service  Under Task Definition ###
# resource "aws_ecs_service" "ecs_service" {
#  name              = "stack-Clixx-services"
#  cluster           = aws_ecs_cluster.Stack_cluster_Clixx.id
#  task_definition   = aws_ecs_task_definition.Clixx_task.arn
#  desired_count   = 2

#  network_configuration {
#      subnets = [
#     element(aws_subnet.private_subnets1.*.id, 0),
#     element(aws_subnet.private_subnets2.*.id, 0)
#   ]
#     security_groups = [aws_security_group.ecs-sg.id]
#     assign_public_ip = false
#   }

#  force_new_deployment = true
#  placement_constraints {
#    type = "distinctInstance"
#  }

#  triggers = {
#    redeployment = timestamp()
#  }

#  load_balancer {
#     target_group_arn = aws_lb_target_group.app_target_group.arn
#     container_name   = "Clixx-Container"
#     container_port   = 80
#   }

#  depends_on = [aws_autoscaling_group.app_asg]
# }


## Creating the Service  Under Task Definition ###

###### CREATING CLUSTER FOR BLOG ########
## Creating the ECS Cluster ###
# resource "aws_ecs_cluster" "Stack_cluster_blog" {
#   name = "blog-ecs-cluster"
# }
# ### Creating the Task Definition ###
# resource "aws_ecs_task_definition" "blog_task" {
#   family                    = "blog-task"
#   container_definitions     = <<DEFINITION
# [
#   {
#     "name": "Blog-Container",
#     "image": "${data.aws_ecr_repository.ecr_repository.repository_url}:latest",
#     "essential": true,
#     "portMappings": [
#       {
#         "containerPort": 80,
#         "hostPort": 80
#       }
#     ],
#     "memory": 512,
#     "cpu": 256,
#     "networkMode": "awsvpc"
#   }
# ]
#   DEFINITION
#   requires_compatibilities  = ["EC2"]
#   network_mode              = "awsvpc"
#   memory                    = 512
#   execution_role_arn        = aws_iam_role.ecsTaskExecutionRole2.arn
#   task_role_arn             = aws_iam_role.ecsTaskExecutionRole2.arn
#   cpu                       = 256
#    runtime_platform {
#     operating_system_family = "LINUX"
#     cpu_architecture = "X86_64"
#   }
# }
# ## Creating the Service  Under Task Definition ###
# resource "aws_ecs_service" "blog_services" {
#   name              = "stack-blog-services"
#   cluster           = aws_ecs_cluster.Stack_cluster_blog.id
#   task_definition   = aws_ecs_task_definition.blog_task.arn
#   launch_type       = "EC2"
#   scheduling_strategy = "REPLICA"
#   desired_count     = 2
#   depends_on = [#aws_lb_listener.listener2,#
#                 aws_ecs_task_definition.blog_task, aws_launch_configuration.TF-Stack-Template2]
#    network_configuration {
#       subnets = [
#       length(aws_subnet.private_subnets1) > 0 ? aws_subnet.private_subnets1[0].id : null,
#       length(aws_subnet.private_subnets2) > 0 ? aws_subnet.private_subnets2[0].id : null
#     ]
#     security_groups = [aws_security_group.stack-ecs-sg.id]
#     assign_public_ip = false
#   }
#    load_balancer {
#     target_group_arn = aws_lb_target_group.TF_STACKGROUP2.arn
#     container_name   = "Blog-Container"
#     container_port   = 80
#   }
# }






