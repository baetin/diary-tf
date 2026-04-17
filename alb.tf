resource "aws_lb" "diary_alb" {
  name               = "diary-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_c.id]
}

resource "aws_lb_target_group" "diary_tg" {
  name     = "diary-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/api/health"
    port = "3000"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.diary_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.diary_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:ap-northeast-2:596517178001:certificate/b40e899b-faf6-4d5f-97d3-961d08f7f106"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.diary_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "diary_attach" {
  target_group_arn = aws_lb_target_group.diary_tg.arn
  target_id        = aws_instance.diary_server.id
  port             = 3000
}