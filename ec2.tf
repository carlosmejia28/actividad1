resource "aws_security_group" "security_esp" {
  name        = "security_esp"
  description = "security_esp"
  vpc_id      = aws_vpc.main.id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_esp"
  }
}

resource "aws_instance" "ec2-1" {
  ami           = "ami-01b799c439fd5516a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1.id
  associate_public_ip_address = true
  key_name      = "llave"

  vpc_security_group_ids = [aws_security_group.security_esp.id]

  tags = {
    Name = "inst_1"
  }
}

resource "aws_instance" "ec2-2" {
  ami           = "ami-01b799c439fd5516a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_2.id
  associate_public_ip_address = true
  key_name      = "llave"

  vpc_security_group_ids = [aws_security_group.security_esp.id]

  tags = {
    Name = "inst_2"
  }
}
