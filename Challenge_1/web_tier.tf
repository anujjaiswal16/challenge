resource "aws_alb" "external_alb" {
	count = var.enabled > 0 ? 1 : 0
	internal = false
	load_balancer_type = "application"
	subnets = "${element(aws_subnet.public_subnet.*.id, count.index)}"
	security_groups = [aws_security_group.aws_alb_frontend_sg.id]
	enable_deletion_protection = var.enable_disable_deletion_protection
	idle_timeout = var.alb_idle_timeout
	enable_cross_zone_load_balancing = "true"
	tags = merge(
    {
      "Name" = "external-frontend-${var.app}-alb"
    },
    var.tag_map,
  )
}

resource "aws_security_group" "aws_alb_frontend_sg" {
	name = "${var.app}-external-alb-sg"
	description = "Ingress to ${var.app} External ALB from network"
	vpc_id = "${aws_vpc.main.id}"
	
	ingress {
		description      = "HTTPS From Internet"
		from_port        = var.frontend_port
		to_port          = var.frontend_port
		protocol         = "tcp"
		cidr_blocks      = [0.0.0.0/0]
		ipv6_cidr_blocks = ["::/0"]
  }

    egress {
		from_port        = 0
		to_port          = 0
		protocol         = "-1"
		cidr_blocks      = ["0.0.0.0/0"]
		ipv6_cidr_blocks = ["::/0"]
  }
	
	tags = var.tag_map
	
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.external_alb.arn
  port              = var.frontend_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.ssl_certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_servers.arn
  }
}

resource "aws_lb_target_group" "web_servers" {
  name     = "${var.app}-webserver-tg"
  port     = var.webserver_port
  protocol = "HTTPS"
  vpc_id   = aws_vpc.main.id
  tags     = var.tag_map
}


resource "aws_launch_template" "web_launch_template" {
  name = "${var.app}-webserver-launch-template"
  image_id = var.websever_ami
  instance_type = var.instance_type
  key_name = var.keypair_name
  user_data = base64encode(var.user_data)
  vpc_security_group_ids = [aws_security_group.aws_webserver_sg.id]
  tags     = var.tag_map
  
    iam_instance_profile {
    name = var.iam_instance_profile
  }
  
    monitoring {
    enabled = true
  }


  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.volume_size
	  volume_type = var.volume_type
	  delete_on_protection = true
    }
  }
  
  tag_specifications {
    resource_type = "instance"
    tags     = var.tag_map
  }
  
  tag_specifications {
    resource_type = "volume"
    tags     = var.tag_map
  }
  
}

resource "aws_security_group" "aws_webserver_sg" {
	name = "${var.app}-webserver-sg"
	description = "Ingress to ${var.app} webserver from ALB"
	vpc_id = "${aws_vpc.main.id}"
	
	ingress {
		description      = "HTTPS From Frontend"
		from_port        = var.webserver_port
		to_port          = var.webserver_port
		protocol         = "tcp"
		source_security_group_id      = aws_security_group.aws_alb_frontend_sg.id
  }

    egress {
		from_port        = 0
		to_port          = 0
		protocol         = "-1"
		cidr_blocks      = ["0.0.0.0/0"]
		ipv6_cidr_blocks = ["::/0"]
  }
	
	tags = var.tag_map
	
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "${var.app}-webserver-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  force_delete              = false
  launch_template           = aws_launch_template.web_launch_template.id
  vpc_zone_identifier       = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  
  target_group_arns         =  aws_lb_target_group.web_servers.arn

  initial_lifecycle_hook {
    name                 = "web_asg_lifecycle_hook"
    default_result       = "CONTINUE"
    heartbeat_timeout    = var.heartbeat_timeout
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
}
  }



