resource "aws_instance" "bastion-server" {
  count = length(var.public_subnet_cidrs)
  ami                     = data.aws_ami.stack_ami.id
  instance_type           = var.instance_type
  vpc_security_group_ids  = [aws_security_group.public-sg.id]
  associate_public_ip_address = true
  iam_instance_profile    ="ec2-to-s3admin"
  key_name                = "stackdevops"
  user_data = base64encode(data.template_file.keybootstrap.rendered)
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)

  tags = {
   Name = "bastion-server-clixx"
 }
}
    
#bastion server for the blog
resource "aws_instance" "bastion-server2" {
  count = length(var.public_subnet_cidrs)
  ami                     = data.aws_ami.stack_ami.id
  instance_type           = var.instance_type
  vpc_security_group_ids  = [aws_security_group.public-sg.id]
  associate_public_ip_address = true
  iam_instance_profile    ="ec2-to-s3admin"
  key_name                = "stackdevops"
  user_data = base64encode(data.template_file.keybootstrap.rendered)
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)

  tags = {
   Name = "bastion-server-blog"
 }
}