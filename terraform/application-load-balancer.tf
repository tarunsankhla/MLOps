resource "aws_alb" "ecs-load-balancer" {
    name                = var.alb_name
    internal            = false
    load_balancer_type  = "application"
    security_groups     = ["${aws_security_group.test_public_sg.id}"]
    subnets             = ["${aws_subnet.test_public_sn_01.id}", "${aws_subnet.test_public_sn_02.id}"]

    tags = {
      Name = var.alb_name
    }
}

resource "aws_alb_target_group" "ecstargetgroupyolo" {
    name                = var.yoloflask_target_group_name
    port                = "${var.yoloflask_container_port}"
    protocol            = "HTTP"
    vpc_id              = "${aws_vpc.test_vpc.id}"
    health_check {
        healthy_threshold   = "${var.health_check_healthy_threshold}"
        unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
        interval            = "${var.health_check_interval}"
        matcher             = var.health_check_matcher
        path                = var.yoloflask_health_check_path
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "${var.health_check_timeout}"
    }
    tags = {
      Name = var.yoloflask_target_group_name
    }
}

resource "aws_alb_target_group" "ecstargetgroupdepth" {
    name                = var.depthanythingflask_target_group_name
    port                = "${var.depthanythingflask_container_port}"
    protocol            = "HTTP"
    vpc_id              = "${aws_vpc.test_vpc.id}"

    health_check {
        healthy_threshold   = "${var.health_check_healthy_threshold}"
        unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
        interval            = "${var.health_check_interval}"
        matcher             = var.health_check_matcher
        path                = var.depthanythingflask_health_check_path
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "${var.health_check_timeout}"
    }

    tags = {
      Name = var.depthanythingflask_target_group_name
    }
}

resource "aws_alb_target_group" "ecstargetgroupreact" {
    name                = var.objectdetectionreact_target_group_name
    port                = "${var.objectdetectionreact_container_port}"
    protocol            = "HTTP"
    vpc_id              = "${aws_vpc.test_vpc.id}"

    health_check {
        healthy_threshold   = "${var.health_check_healthy_threshold}"
        unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
        interval            = "${var.health_check_interval}"
        matcher             = var.health_check_matcher
        path                = var.objectdetectionreact_health_check_path
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "${var.health_check_timeout}"
    }

    tags = {
      Name = var.objectdetectionreact_target_group_name
    }
}

resource "aws_alb_listener" "alb_listener" {
    load_balancer_arn = "${aws_alb.ecs-load-balancer.arn}"
    port              = "${var.alb_listener_port}"
    protocol          = "HTTP"

    default_action {
        type = "forward"
        forward {
            target_group {
                arn = "${aws_alb_target_group.ecstargetgroupreact.arn}"
            }

            stickiness {
                enabled  = true
                duration = var.alb_stickiness_duration
            }
        }
    }
}

resource "aws_lb_listener_rule" "yoloflask_rule" {
  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = var.alb_listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecstargetgroupyolo.arn
  }

  condition {
    path_pattern {
      values = var.yoloflask_path_patterns
    }
  }
}

resource "aws_lb_listener_rule" "depthanythingflask_rule" {
  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = var.alb_listener_rule_priority + 1

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecstargetgroupdepth.arn
  }

  condition {
    path_pattern {
      values = var.depthanythingflask_path_patterns
    }
  }
}

