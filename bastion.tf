resource "aws_instance" "bastion-server" {
  count = length(var.public_subnet_cidrs)
  ami                     = data.aws_ami.stack_ami.id
  instance_type           = var.instance_type
  vpc_security_group_ids  = [aws_security_group.public-sg.id]
  associate_public_ip_address = true
  #user_data               = data.template_file.blogbootstap.rendered
  key_name                = aws_key_pair.Stack_KP.key_name
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)

  tags = {
   Name = "bastion-server"
 }
}
    
#bastion server for the blog
resource "aws_instance" "bastion-server2" {
  count = length(var.public_subnet_cidrs)
  ami                     = data.aws_ami.stack_ami.id
  instance_type           = var.instance_type
  vpc_security_group_ids  = [aws_security_group.public-sg.id]
  associate_public_ip_address = true
  key_name                = aws_key_pair.Stack_KP.key_name
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)

  tags = {
   Name = "bastion-server-blog"
 }
}