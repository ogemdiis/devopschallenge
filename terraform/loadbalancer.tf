resource "aws_lb" "lb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  enable_deletion_protection = true

 

  tags = {
    Environment = "test"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "tf-lb-alb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "alb_attach" {
    for_each = aws_instance.web
    target_group_arn = aws_lb_target_group.alb_tg.arn
    target_id        = aws_instance.web.id
    port             = 80
}
