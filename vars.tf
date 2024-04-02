
variable "environment" {
  default = "dev"
}

variable "system" {
  default = "Retail Reporting"
}

variable "subsystem" {
  default = "CliXX"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "my_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "my_key.pub"
}

variable "OwnerEmail" {
  default = "Dolapo832@gmail.com"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-stack-1.0"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}

variable "public_subnet_cidrs" {
  type = list(string)
  description = "Public Subnet CIDR values"
  default = [ 
    "10.0.2.0/23",
    "10.0.4.0/23"
    ]
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "Private Subnet CIDR values"
  default = [ 
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.8.0/22",
    "10.0.12.0/22",
    "10.0.16.0/24",
    "10.0.17.0/24",
    "10.0.18.0/26",
    "10.0.19.0/26",
    "10.0.20.0/26",
    "10.0.21.0/26"
    ]
}


variable "MOUNT_POINT" {
  default="/var/www/html"
}

variable "GIT_REPO" {
  default="https://github.com/stackitgit/CliXX_Retail_Repository.git"
}

variable "MOUNT_POINT1" {
  default="/var/www/html"
}

variable "GIT_REPO1" {
  default="https://github.com/Dolapo832/STACK_BLOG.git"
}

variable "azs" {
  type        = list(string)
  default = [
     "us-east-1a",
     "us-east-1b"      
  ]
}

variable "subnet_count" {
  type = map(number)
  default = {
    "public_subnets"  = 2,
    "private_subnets" = 10
  }
}

variable "subnet_count_per_az" {
  type    = number
  default = 5 // Number of private subnets per availability zone
}
















