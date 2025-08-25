resource "google_compute_region_network_endpoint_group" "neg" {
  name                  = "cloudrunneg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project = var.service_project_id
  cloud_run {
    service = module.cloud_run.service_name
  }
}