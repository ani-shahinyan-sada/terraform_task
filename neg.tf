resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  project               = var.service_project_id
  name                  = "${var.network_name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = var.network_name  
  }

  depends_on = [module.cloud_run]
}