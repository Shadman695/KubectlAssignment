provider "aws" {
  region = "us-east-1"
}

# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch the default subnets within the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Select the first default subnet
data "aws_subnet" "default" {
  id = data.aws_subnets.default.ids[0]
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-00beae93a2d981137" # Example AMI ID, specify a valid AMI for your region
  instance_type = "t2.micro"

  subnet_id = data.aws_subnet.default.id

  tags = {
    Name = "Assignment1EC2"
  }

  key_name = aws_key_pair.my_key_pair.key_name
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my_key_pair"
  public_key = file("~/.ssh/id_rsa.pub") # Path to your public key
}

output "instance_id" {
  value = aws_instance.my_ec2.id
}

output "instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "instance_az" {
  value = aws_instance.my_ec2.availability_zone
}
