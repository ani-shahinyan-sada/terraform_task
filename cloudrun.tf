# resource "google_cloud_run_service_iam_member" "public_access" {
#   project  = var.service_project_id
#   location = var.region
#   service  = google_cloud_run_v2_service.default.name
#   role     = "roles/run.invoker"
#   member   = "allUsers"
# }

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
        # network    = module.vpc.network_name
        # subnetwork = module.vpc.subnets_names[0]
        network    = "projects/${var.host_project_id}/global/networks/${var.network_name}"
        subnetwork = "projects/${var.host_project_id}/regions/${var.region}/subnetworks/${module.vpc.subnets_names[0]}"
      }
      egress = "PRIVATE_RANGES_ONLY"
    }
  }
  depends_on = [module.artifact_registry, google_project_iam_member.cloud_run_service_agent_network_user]
}

resource "google_project_iam_member" "cloud_run_service_agent_network_user" {
  project = var.host_project_id  # ani-proj-1 (host project)
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:service-921523404452@serverless-robot-prod.iam.gserviceaccount.com"
}