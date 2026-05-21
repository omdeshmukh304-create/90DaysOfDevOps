module "security_group" {
  source = "./modules/security-group"

  sg_name = "module-sg"
  vpc_id  = var.vpc_id
}

module "ec2_instance" {
  source = "./modules/ec2-instance"

  instance_name   = var.instance_name
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  security_groups = [module.security_group.security_group_id]
}