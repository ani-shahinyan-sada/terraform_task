module "cloud_run" {
  source  = "GoogleCloudPlatform/cloud-run/google"
  version = "~> 0.9"  
  service_name          = var.network_name
  project_id            = var.service_project_id
  location              = var.region
  image                 = "us-west1-docker.pkg.dev/ani-proj-2/terraform-task/app:latest"
  service_account_email = var.service_account_email
  
  env_vars = [
    {
      name  = "DB_CONNECTION"
      value = module.mysql-db.instance_connection_name
    }
  ]
}
# remove the connector and make it an egress 
resource "google_vpc_access_connector" "connector" {
  name          = "vpc-connector"
  subnet {
    name = "vpc-connector-subnet"
    project_id = var.host_project_id
  }
  region        = var.region
  project       = var.service_project_id
  max_instances = 3 
  min_instances = 2
  depends_on = [module.vpc]
}