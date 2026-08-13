module "networking" {
  source = "./modules/networking"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  ssh_allowed_cidr   = var.ssh_allowed_cidr
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "compute" {
  source = "./modules/compute"

  project_name          = var.project_name
  instance_type         = var.instance_type
  instance_count        = var.instance_count
  subnet_id             = module.networking.subnet_id
  security_group_id     = module.networking.security_group_id
  instance_profile_name = module.iam.instance_profile_name
  key_name              = var.key_name
}

module "notifications" {
  source = "./modules/notifications"

  project_name = var.project_name
  alarm_email = var.alarm_email
  alarm_sms = var.alarm_sms
}

module "monitoring" {
  source = "./modules/monitoring"

  project_name = var.project_name
  instance_ids  = module.compute.instance_ids
  sns_topic_arn = module.notifications.topic_arn
}