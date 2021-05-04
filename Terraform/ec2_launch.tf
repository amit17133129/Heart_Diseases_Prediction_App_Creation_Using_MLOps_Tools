provider "aws" {
  region     = "ap-south-1"
  access_key = "AXXXXXXXXXXXXXXXXXXX"
  secret_key = "AXXXXXXXXXXXXXXXXXXX"
  profile    = "Amit"
}
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "192.168.0.0/16"
}

variable "cidr_subnet1" {
  description = "CIDR block for the subnet"
  default = "192.168.1.0/24"
}


variable "availability_zone" {
  description = "availability zone to create subnet"
  default = "ap-south-1"
}
variable "environment_tag" {
  description = "Environment tag"
  default = "Production"

}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags ={
    Environment = "${var.environment_tag}"
    Name= "TerraformVpc"
  }
}

resource "aws_subnet" "subnet_public1_Lab1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_subnet1}"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"
  tags ={
    Environment = "${var.environment_tag}"
    Name= "TerraformPublicSubnetLab1"
  }

}

resource "aws_security_group" "TerraformSG" {
  name = "TerraformSG"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags ={
    Environment = "${var.environment_tag}"
    Name= "TerraformSG"
  }

}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "Terraform_IG"
  }
}
resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "TerraformRouteTable"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  route_table_id = "${aws_route_table.r.id}"
}


resource "aws_instance" "Ansible_Controller_Node" {
  ami           = "ami-0a9d27a9f4f5c0efc"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "Ansible_Controller_Node"
  }

}
resource "aws_instance" "K8S_Master_Node" {
  ami           = "ami-0d758c1134823146a"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "K8S_Master_Node"
  }

}
resource "aws_instance" "K8S_Slave1_Node" {
  ami           = "ami-0d758c1134823146a"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "K8S_Slave1_Node"
  }

}
resource "aws_instance" "K8S_Slave2_Node" {
  ami           = "ami-0d758c1134823146a"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "K8S_Slave2_Node"
  }

}
resource "aws_instance" "JenkinsNode" {
  ami           = "ami-0a9d27a9f4f5c0efc"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "JenkinsNode"
  }

}
resource "aws_instance" "DockerNode" {
  ami           = "ami-0a9d27a9f4f5c0efc"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet_public1_Lab1.id}"
  vpc_security_group_ids = ["${aws_security_group.TerraformSG.id}"]
  key_name = "007ab"
 tags ={
    Environment = "${var.environment_tag}"
    Name= "DockerNode"
  }

}
