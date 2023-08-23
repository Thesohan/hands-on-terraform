provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "terraform_tests_data_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Owner = "sohan"
  }
}

resource "aws_subnet" "terraform_tests_public_subnet" {
  vpc_id                  = aws_vpc.terraform_tests_data_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Owner = "sohan"
  }
}

resource "aws_subnet" "terraform_tests_private_subnet" {
  vpc_id            = aws_vpc.terraform_tests_data_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Owner = "sohan"
  }
}

resource "aws_security_group" "terraform_tests_sg" {
  name        = "terraform-tests-sg"
  description = "Terraform tests Security Group"
  vpc_id      = aws_vpc.terraform_tests_data_vpc.id

  # Inbound rule for HTTP on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Owner = "sohan"
  }

}

resource "aws_network_acl" "terraform_tests_nacl" {
  vpc_id = aws_vpc.terraform_tests_data_vpc.id

  # Inbound rule for HTTP on port 80
  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
    rule_no    = 100
  }
  tags = {
    Owner = "sohan"
  }
}

resource "aws_instance" "terraform_tests_instance" {
  ami             = "ami-08a52ddb321b32a8c"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.terraform_tests_public_subnet.id # This will place the instance in the public subnet
  security_groups = [aws_security_group.terraform_tests_sg.name]

  tags = {
    Name  = "TerraformTestsEC2Instance"
    Owner = "sohan"
  }
}

resource "aws_instance" "terraform_tests_private_instance" {
  ami             = "ami-08a52ddb321b32a8c"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.terraform_tests_private_subnet.id # This will place the instance in the private subnet
  security_groups = [aws_security_group.terraform_tests_sg.name]

  tags = {
    Name  = "TerraformTestsPrivateInstance"
    Owner = "sohan"
  }
}

resource "aws_ebs_volume" "terraform_tests_public_ebs" {
  availability_zone = aws_instance.terraform_tests_instance.availability_zone
  size              = 10
  tags = {
    Owner = "sohan"
  }
}

resource "aws_volume_attachment" "terraform_tests_public_ebs_attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.terraform_tests_public_ebs.id
  instance_id = aws_instance.terraform_tests_instance.id
  # tags = {
  #   Owner = "sohan"
  # }
}

resource "aws_ebs_volume" "private_ebs" {
  availability_zone = aws_instance.terraform_tests_private_instance.availability_zone
  size              = 10
  tags = {
    Owner = "sohan"
  }
}

resource "aws_volume_attachment" "private_ebs_attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.private_ebs.id
  instance_id = aws_instance.terraform_tests_private_instance.id
  # tags = {
  #   Owner = "sohan"
  # }
}
