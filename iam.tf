resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.service_project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${var.service_account_email}"
}

resource "google_project_iam_member" "cloudsql_client" {
  project = var.service_project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${var.service_account_email}"
}

resource "google_project_iam_member" "vpc_access_network_user" {
  project = var.host_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:service-921523404452@gcp-sa-vpcaccess.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "google_apis_service_agent_editor" {
  project = var.host_project_id
  role    = "roles/editor"
  member  = "serviceAccount:921523404452@cloudservices.gserviceaccount.com"
}
