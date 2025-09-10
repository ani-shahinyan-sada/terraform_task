module "artifact_registry" {
  source        = "GoogleCloudPlatform/artifact-registry/google"
  version       = "~> 0.3"
  project_id    = var.service_project_id
  location      = var.region
  format        = "DOCKER"
  repository_id = "ani"
  cleanup_policies = {
    most_recent_versions = {
      keep_count = 3
    }
  }
}