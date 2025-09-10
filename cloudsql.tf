module "mysql-db" {
  source              = "terraform-google-modules/sql-db/google//modules/mysql"
  version             = "~> 26.1"
  name                = var.db_name
  database_version    = "MYSQL_8_0"
  project_id          = var.service_project_id
  zone                = var.zone
  region              = var.region
  tier                = var.instance_tier
  deletion_protection = true


  db_name      = "default"
  db_charset   = "utf8"
  db_collation = "default"

  user_name     = "default"
  user_password = var.user_password
  user_host     = "%"

  ip_configuration = {
    ipv4_enabled    = false
    private_network = module.vpc.network_self_link
    ssl_mode        = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
  }
  depends_on = [module.private_service_connect]

}
