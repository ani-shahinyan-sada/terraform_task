module "mysql-db" {
  source              = "terraform-google-modules/sql-db/google//modules/mysql"
  version             = "~> 26.1"
  name                = var.db_name
  database_version    = "MYSQL_8_0"
  project_id          = var.service_project_id
  zone                = var.zone
  region              = var.region
  tier                = var.instance_tier
  deletion_protection = false

  ip_configuration = {
    ipv4_enabled       = false
    private_network    = module.vpc.network_self_link
    ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    allocated_ip_range = google_compute_global_address.private_ip_address.name
  }

}
