# resource "aws_efs_file_system" "foo" {
#   creation_token = "my-efs"
#   tags = {
#     Name = "MyProduct"
#   }
# }


# resource "aws_efs_mount_target" "alpha" {
#   file_system_id =  aws_efs_file_system.foo.id
#   avaliability_zone
#   security_groups = [aws_security_group.db-sg.id]
# }