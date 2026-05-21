
# VPC

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "TerraformDemoVPC"
  }
}
# Public Subnet
resource "aws_subnet" "demo_subnet" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "TerraformDemoSubnet"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "TerraformDemoIGW"
  }
}
# Route Table
resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }
  tags = {
    Name = "TerraformDemoRouteTable"
  }
}
# Route Table Association
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo_route_table.id
}
# Security Group
resource "aws_security_group" "demo_security_group" {
  name        = "TerraWeek-5G"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.demo_vpc.id
  # SSH Access
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP Access
  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerraformDemoSG"
  }
}


# EC2 Instance

# resource "aws_instance" "demo_instance" {
#   ami           = "ami-0f5ee92e2d63afc18"
#   instance_type = "t2.micro"

#   subnet_id = aws_subnet.demo_subnet.id

#   vpc_security_group_ids = [
#     aws_security_group.demo_security_group.id
#   ]

#   associate_public_ip_address = true

#   tags = {
#     Name = "TerraWeek-Day5"
#   }
# }
resource "aws_instance" "demo_instance" {
  ami           = "ami-03f4878755434977f"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.demo_subnet.id

  vpc_security_group_ids = [
    aws_security_group.demo_security_group.id
  ]

  associate_public_ip_address = true

  # Lifecycle Rules
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "TerraWeek-Day5"
  }
}
# S3 Bucket for Application Logs
resource "aws_s3_bucket" "app_logs" {
  bucket = "terraweek-app-logs-omdeshmukh-2026"

  depends_on = [aws_instance.demo_instance]

  tags = {
    Name = "TerraWeek-App-Logs"
  }
}