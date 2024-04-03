resource "aws_efs_file_system" "foo" {
  creation_token = "my-efs"
  tags = {
    Name = "MyProduct"
  }
}


resource "aws_efs_mount_target" "alpha" {
  file_system_id =  aws_efs_file_system.foo.id
  subnet_id = [
    element(aws_subnet.private_subnets.*.id, 2),
    element(aws_subnet.private_subnets.*.id, 3)
  ]
  security_groups = [aws_security_group.db-sg.id]
}