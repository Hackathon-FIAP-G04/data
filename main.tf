module "vpc" {
  source = "./module/vpc"
  prefix = var.prefix
}

module "rds" {
  source = "./module/rds"
  db_engine = var.db_engine
  db_name = var.db_name
  db_engine_version = var.db_engine_version
  db_user = var.db_user
  db_password = var.db_password
  prefix = var.prefix
  subnet_ids = module.vpc.subnet_ids
  vpc_id = module.vpc.vpc_id
}

module "atlas-mongodb" {
  source = "./module/atlas"
  atlas_org_id = var.atlas_org_id
  atlas_project_name = var.prefix
  environment = "dev"
  cluster_instance_size_name = "M0"
  cloud_provider = "AWS"
  atlas_region = "US_WEST_2"
  mongodb_version = "6.0"
  cidr_block = "0.0.0.0/0"
  db_password = var.db_password
}

output "rds_db_host" {  value = module.rds.rds_db_host }
output "atlas_cluster_connection_string" { value = module.atlas-mongodb.atlas_cluster_connection_string }