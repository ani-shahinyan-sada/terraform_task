# resource "google_compute_address" "psc_endpoint" {
#   project      = var.host_project_id
#   name         = "cloudsql-psc-endpoint"
#   region       = var.region
#   address_type = "INTERNAL"
#   subnetwork   = module.vpc.subnets["${var.region}/subnet-01"].self_link
# }

# resource "google_compute_forwarding_rule" "psc_endpoint" {
#   project    = var.host_project_id
#   name       = "cloudsql-psc-endpoint"
#   region     = var.region
#   target     = module.mysql-db.psc_service_attachment_link
#   network    = module.vpc.network_self_link
#   ip_address = google_compute_address.psc_endpoint.address
# }