module "vpc" {
  source = "./modules/vpc"

  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr

  tags = local.common_tags
}

module "security_group" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id

  tags = local.common_tags
}

module "ec2_instance" {
  source = "./modules/ec2-instance"

  ami_id           = var.ami_id
  instance_type    = var.instance_type
  subnet_id        = module.vpc.subnet_id
  security_group_id = module.security_group.sg_id

  tags = local.common_tags
}