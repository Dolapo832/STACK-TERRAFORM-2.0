
resource "aws_key_pair" "Stack_KP" {
  key_name   = "stackppp"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_security_group" "public-sg" {
  vpc_id     = aws_vpc.main.id
  name        = "Stack-WebDZ1"
  description = "Stack IT Security Group For my vpc and public subnet"
}

resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https" {
  security_group_id = aws_security_group.public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}



resource "aws_security_group_rule" "nfs" {
  security_group_id = aws_security_group.public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 2049
  to_port           = 2049
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "mysql" {
  security_group_id = aws_security_group.public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "Oracle-RDS" {
  security_group_id = aws_security_group.public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 1521
  to_port           = 1521
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.public-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 00
  to_port           = 00
  cidr_blocks       = ["0.0.0.0/0"]
}

#security group for the private subnets 
resource "aws_security_group" "private-sg" {
  vpc_id     = aws_vpc.main.id
  name   = "db-sg"

  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp" 
    security_groups = [aws_security_group.public-sg.id] 
    # Allow traffic from the public subnets
  }

ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.public-sg.id] # Allow traffic from the public subnets 
    
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp" 
    security_groups = [aws_security_group.public-sg.id] # Allow traffic from the public subnets
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.public-sg.id] # Allow traffic from the public subnets
   
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.public-sg.id] # Allow traffic from the public subnets  
    

  }

ingress {
    from_port         = -1   # ICMP type (any)
    to_port           = -1   # ICMP code (any)
    protocol          = "icmp" 
    security_groups = [aws_security_group.public-sg.id] # Allow traffic from the public subnets
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}



