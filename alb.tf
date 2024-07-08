# Balanceador de carga
resource "aws_lb" "alb" {
  name               = "alb-2024"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.subred_publica_1.id, aws_subnet.subred_publica_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "alb-2024"
  }
}

# Grupo objetivo
resource "aws_lb_target_group" "alb" {
  name     = "target-group-2024"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_principal.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "grupo_objetivo"
  }
}

# Escuchador
resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }

  tags = {
    Name = "escuchador"
  }
}

# Adjuntar instancia web_1 al grupo objetivo
resource "aws_lb_target_group_attachment" "web_1" {
  target_group_arn = aws_lb_target_group.alb.arn
  target_id        = aws_instance.web_1.id
  port             = 80
}

# Adjuntar instancia web_2 al grupo objetivo
resource "aws_lb_target_group_attachment" "web_2" {
  target_group_arn = aws_lb_target_group.alb.arn
  target_id        = aws_instance.web_2.id
  port             = 80
}
