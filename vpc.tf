# Proveedor AWS
provider "aws" {
  region = "us-west-2"
}

# VPC principal
resource "aws_vpc" "vpc_principal" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "mi-vpc-esp-2024"
  }
}

# Puerta de enlace a Internet
resource "aws_internet_gateway" "puerta_internet" {
  vpc_id = aws_vpc.vpc_principal.id

  tags = {
    Name = "mi-igw-esp-2024"
  }
}

# Subred pública 1
resource "aws_subnet" "subred_publica_1" {
  vpc_id = aws_vpc.vpc_principal.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "us-west-2a"

  tags = {
    Name = "subred_publica_1"
  }
}

# Subred pública 2
resource "aws_subnet" "subred_publica_2" {
  vpc_id = aws_vpc.vpc_principal.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "us-west-2b"

  tags = {
    Name = "subred_publica_2"
  }
}

# Subred privada 1
resource "aws_subnet" "subred_privada_1" {
  vpc_id = aws_vpc.vpc_principal.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "us-west-2a"

  tags = {
    Name = "subred_privada_1"
  }
}

# Subred privada 2
resource "aws_subnet" "subred_privada_2" {
  vpc_id = aws_vpc.vpc_principal.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "us-west-2b"

  tags = {
    Name = "subred_privada_2"
  }
}

# Tabla de rutas públicas
resource "aws_route_table" "tabla_rutas_publicas" {
  vpc_id = aws_vpc.vpc_principal.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.puerta_internet.id
  }

  tags = {
    Name = "tabla_rutas_publicas"
  }
}

# Asociación de tabla de rutas públicas a subred pública 1
resource "aws_route_table_association" "asociacion_publica_1" {
  subnet_id      = aws_subnet.subred_publica_1.id
  route_table_id = aws_route_table.tabla_rutas_publicas.id
}

# Asociación de tabla de rutas públicas a subred pública 2
resource "aws_route_table_association" "asociacion_publica_2" {
  subnet_id      = aws_subnet.subred_publica_2.id
  route_table_id = aws_route_table.tabla_rutas_publicas.id
}

# Tabla de rutas privadas
resource "aws_route_table" "tabla_rutas_privadas" {
  vpc_id = aws_vpc.vpc_principal.id

  tags = {
    Name = "tabla_rutas_privadas"
  }
}

# Asociación de tabla de rutas privadas a subred privada 1
resource "aws_route_table_association" "asociacion_privada_1" {
  subnet_id      = aws_subnet.subred_privada_1.id
  route_table_id = aws_route_table.tabla_rutas_privadas.id
}

# Asociación de tabla de rutas privadas a subred privada 2
resource "aws_route_table_association" "asociacion_privada_2" {
  subnet_id      = aws_subnet.subred_privada_2.id
  route_table_id = aws_route_table.tabla_rutas_privadas.id
}
