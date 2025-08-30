resource "google_cloud_run_v2_service" "default" {
  provider = google-beta
  name     = "python-app-cloudrun"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  project = var.service_project_id
  template {
    containers {
      image = var.image
    }
    vpc_access {
      network_interfaces {
        network    = module.vpc.network_name
        subnetwork = module.vpc.subnets_names[0]

      }
      egress = "PRIVATE_RANGES_ONLY"
    }

  }
  depends_on = [module.artifact_registry]
}
