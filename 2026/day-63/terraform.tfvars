project_name = "terraform-day63"

environment = "dev"

region = "ap-south-1"

instance_type = "t2.micro"

vpc_cidr = "10.0.0.0/16"

subnet_cidr = "10.0.1.0/24"

allowed_ports = [22, 80, 443]

extra_tags = {
  Owner   = "Om"
  Purpose = "Terraform-Practice"
}