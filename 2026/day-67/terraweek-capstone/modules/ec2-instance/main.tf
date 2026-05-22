resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = merge(
    var.tags,
    {
      Name = "${terraform.workspace}-instance"
    }
  )
}