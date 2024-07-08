# Grupo de seguridad para RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.vpc_principal.id

  # Reglas de ingreso
  ingress {
    from_port   = 3306
    to_port     = 3306
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
    Name = "rds_sg"
  }
}

# Instancia de RDS
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  publicly_accessible  = true
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.default.id

  tags = {
    Name = "mi-instancia-rds"
  }
}

# Grupo de subredes para RDS
resource "aws_db_subnet_group" "default" {
  name       = "grupo_subredes_rds"
  subnet_ids = [aws_subnet.subred_publica_1.id, aws_subnet.subred_publica_2.id]

  tags = {
    Name = "grupo_subredes_rds"
  }
}