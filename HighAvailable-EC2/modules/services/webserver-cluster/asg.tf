#Steps:
#Create Launch Config
#Create ASG and use the reference of Launch Config and Target Group
#Create ALB
#Create Target Group
#Create Listener and use ALB reference
#Create Listener Rule and use the reference of Listener and TargetGroup

data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

locals {
  http_port=80
  any_port=0
  any_protocol="-1"
  tcp_protocol="tcp"
  all_ips=["0.0.0.0/0"]

}

resource "aws_launch_configuration" "myLaunchConfig" {
  image_id        = "ami-0194c3e07668a7e36"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance.id]
  key_name="jenkins"

  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
                echo \
                  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
                  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                sudo apt-get update
                sudo apt-get install docker-ce docker-ce-cli containerd.io -y
                sudo systemctl start docker
                sudo docker run -d --name python-app --rm -p 5000:5000 vmalla/python-app:docker-demo
                EOF

  #user_data = file("deploy.sh")
  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  egress {
    cidr_blocks = local.all_ips
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
  }

}
# ASG uses launch configuration to provision the instances and target group to connect to LB
resource "aws_autoscaling_group" "myASG" {
  name                 = "terraform-asg-example"
  launch_configuration = aws_launch_configuration.myLaunchConfig.name
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids
  target_group_arns    = [aws_lb_target_group.myTargetGroup.arn]
  health_check_type    = "ELB"
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = true
  }
}

#Create Application Load Balancer
resource "aws_lb" "myELB" {
  name               = "terraform-asg-example"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.alb_sg.id]
}

#You’ll need to tell the aws_lb resource to use the following security group via the security_groups 
#argument
resource "aws_security_group" "alb_sg" {
  name = "${var.cluster_name}-alb"
  #Allow inbound HTTP requests on port 80
  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
  #Allow all outbound requests so that the load balancer can perform health checks
  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }
}

# Listener for ALB which uses ELB ARN
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.myELB.arn
  port              = local.http_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

#Next, you need to create a target group for your ASG using the aws_lb_target_group resource:
resource "aws_lb_target_group" "myTargetGroup" {
  name     = "terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

}

# Listener rule requires listener and target group. Listener rule acts as a bridge between LB and ASG
resource "aws_lb_listener_rule" "myListenerRule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myTargetGroup.arn
  }
}
