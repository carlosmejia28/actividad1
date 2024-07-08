# Grupo de seguridad para la web
resource "aws_security_group" "web_sg" {
  name        = "grupo_seguridad_web"
  description = "Grupo de seguridad para acceso web"
  vpc_id      = aws_vpc.vpc_principal.id

  # Reglas de ingreso
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Reglas de salida
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "grupo_seguridad_web"
  }
}

# Instancia EC2 en la subred pública 1
resource "aws_instance" "web_1" {
  ami                         = "ami-01572eda7c4411960"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subred_publica_1.id
  associate_public_ip_address = true
  key_name                    = "key2"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "instancia_web_1"
  }
}

# Instancia EC2 en la subred pública 2
resource "aws_instance" "web_2" {
  ami                         = "ami-01572eda7c4411960"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subred_publica_2.id
  associate_public_ip_address = true
  key_name                    = "key2"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "instancia_web_2"
  }
}
