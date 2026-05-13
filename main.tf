resource "aws_vpc" "myvpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "Srinu-Vpc"
  }
}
resource "aws_subnet" "mysubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-1d"
  tags = {
    Name = "Srinu-Subnet"
  }
}
resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "Srinu-IGW"
  }
}
resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }
  tags = {
    Name = "Srinu-Route-Table"
  }
}
resource "aws_route_table_association" "myassociation" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myroute.id
}
resource "aws_security_group" "mysg" {
  name        = "allow-all"
  description = "Allow all inbound outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

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

  tags = {
    Name = "allow-all-sg"
  }
}
resource "aws_instance" "myinstance" {
  ami                         = "ami-091138d0f0d41ff90"
  key_name                    = "pem200426"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.mysubnet.id
  vpc_security_group_ids      = [aws_security_group.mysg.id]
  associate_public_ip_address = true
  tags = {
    Name = "Srinu-Instance"
  }
}
output "infrastructure_details" {
  value = {
    vpc_id                   = aws_vpc.myvpc.id
    subnet_id                = aws_subnet.mysubnet.id
    internet_gateway_id      = aws_internet_gateway.myIGW.id
    route_table              = aws_route_table.myroute.id
    route_table_association  = aws_route_table_association.myassociation.id
    security_group_id        = aws_security_group.mysg.id
    instance_id              = aws_instance.myinstance.id
  }
}
