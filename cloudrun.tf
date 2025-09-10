resource "google_cloud_run_v2_service" "default" {
  provider = google-beta
  name     = "python-app-cloudrun"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  project  = var.service_project_id
  template {
    containers {
      image = var.image
      depends_on = [module.artifact_registry]
    }
    vpc_access {
      network_interfaces {
        network    = "projects/${var.host_project_id}/global/networks/${var.network_name}"
        subnetwork = "projects/${var.host_project_id}/regions/${var.region}/subnetworks/${module.vpc.subnets_names[0]}"
      }
      egress = "PRIVATE_RANGES_ONLY"
    }
}
  depends_on = [google_project_iam_member.cloud_run_service_agent_network_user]
}