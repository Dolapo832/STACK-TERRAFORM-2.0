resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "db-subnet-group"
 subnet_ids = [
    element(aws_subnet.private_subnets1.*.id, 2),
    element(aws_subnet.private_subnets2.*.id, 2)
  ]# Specify the private subnet IDs
}

#clixxdb
resource "aws_db_instance" "CLIXX_DB" {
  identifier             = "clixx"
  instance_class         = "db.m6gd.large"
  db_name                = ""
  username               = "wordpressuser"
  password               = "W3lcome123"
  snapshot_identifier    = data.aws_db_snapshot.CLIXXSNAP.id
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${aws_security_group.db-sg.id}"]
  db_subnet_group_name  = aws_db_subnet_group.db-subnet-group.name

  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
}

#blogdb
resource "aws_db_instance" "blog_DB" {
  identifier             = "wordpressinstance-1"
  instance_class         = "db.t3.micro"
  db_name                = ""
  username               = "admin"
  password               = "stackinc"
  snapshot_identifier    = data.aws_db_snapshot.BLOGSNAP.id
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${aws_security_group.db-sg.id}"]
  db_subnet_group_name  = aws_db_subnet_group.db-subnet-group.name

  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
}