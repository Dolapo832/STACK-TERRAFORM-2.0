resource "aws_efs_file_system" "foo" {
  creation_token = "my-efs"
  tags = {
    Name = "clixx-efs"
  }
}


resource "aws_efs_mount_target" "alpha" {
  file_system_id =  aws_efs_file_system.foo.id
  subnet_id      = element(aws_subnet.private_subnets1.*.id, 0)
  security_groups = [aws_security_group.private-sg.id]
}

resource "aws_efs_mount_target" "beta" {
  file_system_id =  aws_efs_file_system.foo.id
  subnet_id      = element(aws_subnet.private_subnets2.*.id, 0)
  security_groups = [aws_security_group.private-sg.id]
  
}

#blog's configuration
resource "aws_efs_file_system" "fool" {
  creation_token = "my-blog-efs"
  tags = {
    Name = "Blog-efs"
  }
}

resource "aws_efs_mount_target" "alpha1" {
  file_system_id =  aws_efs_file_system.fool.id
  subnet_id      = element(aws_subnet.private_subnets1.*.id, 0)
  security_groups = [aws_security_group.private-sg.id]
}

resource "aws_efs_mount_target" "beta1" {
  file_system_id =  aws_efs_file_system.fool.id
  subnet_id      = element(aws_subnet.private_subnets2.*.id, 0)
  security_groups = [aws_security_group.private-sg.id]
  
}





