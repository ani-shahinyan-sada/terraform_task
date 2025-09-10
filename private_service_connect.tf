module "private_service_connect" {
  source  = "terraform-google-modules/sql-db/google//modules/private_service_access"
  version = "~> 26.2"

  project_id  = var.host_project_id
  vpc_network = module.vpc.network_name
  depends_on  = [module.vpc]
}
