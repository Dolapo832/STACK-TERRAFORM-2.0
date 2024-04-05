locals {
  creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

resource "aws_lb" "lb" {
  #depends_on = [aws_efs_mount_target.efs_mount2]
  name               = "LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    element(aws_subnet.public_subnets.*.id, 0),
    element(aws_subnet.public_subnets.*.id, 1)
  ]
 security_groups         = [aws_security_group.public-sg.id]
   tags = {
    Name = " Stack-Load-Balancer"
  }
}

resource "aws_launch_configuration" "stack_pre" {
  name_prefix          = "web-apps"
  depends_on    = [
    aws_efs_mount_target.alpha, aws_efs_mount_target.beta,
    aws_db_instance.CLIXX_DB
  ]
  image_id             = data.aws_ami.stack_ami.id
  instance_type        = var.instance_type
  user_data            = base64encode(data.template_file.bootstrap.rendered)
  security_groups      = [aws_security_group.private-sg.id]

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdc"
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdd"
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sde"
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "app_asg"
  desired_capacity          = 2
  max_size                  = 2
  min_size                  = 2
  vpc_zone_identifier       =  [
    element(aws_subnet.private_subnets1.*.id, 0),
    element(aws_subnet.private_subnets2.*.id, 0)
  ]
  launch_configuration      = aws_launch_configuration.stack_pre.id
  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.app_target_group.arn]

  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}

# Create a target group
 resource "aws_lb_target_group" "app_target_group" {
   name     = "app-target-group"
   port     = 80
   protocol = "HTTP"
   vpc_id = aws_vpc.main.id
       # Specify your VPC ID here
            
  

    health_check {
    path                = "/"
     protocol            = "HTTP"
     port                = 80
     healthy_threshold   = 2
     unhealthy_threshold = 2
     timeout             = 3
     interval            = 30
   }
 }

 resource "aws_lb_listener" "example" {
   load_balancer_arn = aws_lb.lb.arn
   port              = 80
   protocol          = "HTTP"

   default_action {
     type             = "forward"
     target_group_arn = aws_lb_target_group.app_target_group.arn
   }
 }


 #blog's deployment
 

