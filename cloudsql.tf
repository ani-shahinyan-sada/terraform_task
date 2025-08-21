module "mysql-db" {
  source  = "terraform-google-modules/sql-db/google//modules/mysql"
  version = "~> 26.1"

  name                 = var.db_name
  random_instance_name = false
  database_version     = "MYSQL_5_6"
  project_id           = var.service_project_id
  zone                 = var.zone
  region               = var.region

  deletion_protection = false

  ip_configuration = {
    ipv4_enabled       = true
    private_network = module.vpc.network_self_link
    ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    allocated_ip_range = null
  }

  database_flags = [
    {
      name  = "log_bin_trust_function_creators"
      value = "on"
    },
  ]

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc.network_self_link
  project       = var.host_project_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = module.vpc.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
