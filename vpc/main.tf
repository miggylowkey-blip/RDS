resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name        = "${var.client_name}-${var.environment}-vpc" 
    Environment = var.environment
    Managedby   = "Terraform"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.client_name}-${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.client_name}-${var.environment}-public-${var.availability_zones[count.index]}"
    Environment = var.environment
    type        = "public"
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.this.id
  # allocate private subnets after the public subnets by offsetting the index
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + length(var.availability_zones))
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.client_name}-${var.environment}-private-${var.availability_zones[count.index]}"
    Environment = var.environment
    type        = "private"
  }
}

resource "aws_eip" "nat" {
  count  = var.enable_nat ? 1 : 0
  domain = "vpc"

  tags = merge({
    Name        = "${var.client_name}-${var.environment}-nat-eip"
    Environment = var.environment
  }, var.tags)
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat ? 1 : 0
  subnet_id     = aws_subnet.public[0].id
  allocation_id = var.enable_nat ? aws_eip.nat[0].id : null

  tags = merge({
    Name        = "${var.client_name}-${var.environment}-nat-gateway"
    Environment = var.environment
  }, var.tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.client_name}-${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.enable_nat ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[0].id
    }
  }

  tags = {
    Name        = "${var.client_name}-${var.environment}-private-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id 
}

resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id 
}

resource "aws_security_group" "app_sg" {
  name        = "${var.client_name}-${var.environment}-app-sg"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.this.id

  # Example: allow HTTP if explicitly enabled (avoid wide-open rules by default)
  ingress {
    description = "Allow HTTP (example)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allow_public_http ? ["0.0.0.0/0"] : []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.client_name}-${var.environment}-app-sg"
  }, var.tags)
}

resource "aws_security_group" "bastion_sg" {
  name        = "${var.client_name}-${var.environment}-bastion-sg"
  description = "Security group for bastion hosts"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow SSH from trusted CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.trusted_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.client_name}-${var.environment}-bastion-sg"
  }, var.tags)
}

resource "aws_security_group" "rds_security_group" {
  name        = "${var.client_name}-${var.environment}-rds-sg"
  description = "Security group for RDS instances"
  vpc_id      = aws_vpc.this.id

  # Only allow DB port from application security group
  ingress {
    description     = "Allow DB access from app servers"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  # Optionally allow maintenance/SSH from bastion if you manage DB via bastion
  ingress {
    description     = "Allow DB admin from bastion"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.client_name}-${var.environment}-rds-sg"
  }, var.tags)
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.client_name}-${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = merge({
    Name = "${var.client_name}-${var.environment}-db-subnet-group"
  }, var.tags)
}