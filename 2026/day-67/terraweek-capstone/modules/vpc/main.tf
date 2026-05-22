resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(
    var.tags,
    {
      Name = "${terraform.workspace}-vpc"
    }
  )
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${terraform.workspace}-subnet"
    }
  )
}