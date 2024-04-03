

#creating vpc
resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 enable_dns_hostnames = true
 instance_tenancy = "default"
 tags = {
   Name = "Project-VPC"
 }
}


#creating the public-subneT
resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 map_public_ip_on_launch = true
 tags = {
   Name = "Public-Subnet${count.index + 1}"
 }
}
#creating the private-subnets
resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 tags = {
     Name = "Private-Subnet${count.index + 1}"
  }
}


#Creating the Internet gateway 
resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id

 tags = {
   Name = "Project-VPC-IGw"
 }
}

#Creating the Route the table
resource "aws_route_table" "public_route" {
 vpc_id = aws_vpc.main.id
 #route table association
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }
 
 tags = {
   Name = "public-Route-Table"
 }
}

#creating a private route table
resource "aws_route_table" "private_route" {
 vpc_id = aws_vpc.main.id
 tags = {
   Name = "private-Route-Table"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
 route_table_id = aws_route_table.public_route.id
}

#Create an EIP for the NAT-gateway 
resource "aws_eip" "nat-eip" {
  count = length(var.public_subnet_cidrs)
   tags = {
      Name = "nat-eip"
      }
}

#Create a NAT Gateway
resource "aws_nat_gateway" "nat-gateway" {
  count = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat-eip.id[count.index]
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
  tags = {
      Name = "nat-gateway"
      }
}




resource "aws_route" "nat_gateway_route" {
  route_table_id         =  aws_route_table.private_route.id # Specify the ID of your route table
  destination_cidr_block = "0.0.0.0/0"     # Route all internet-bound traffic
  nat_gateway_id         = aws_nat_gateway.nat-gateway.id  # Specify the ID of your NAT Gateway
}


#creating a private route table

