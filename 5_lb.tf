module "gce-lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 9.0"
  project = var.service_project_id
  name    = "db-http-lb"
  # target_tags       = [module.mig1.target_tags, module.mig2.target_tags] bring back when configuring health checks (yete jogem vonc)
  backends = {
    default = {
      protocol    = "HTTPS"
      timeout_sec = 20
      enable_cdn  = false

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group = google_compute_region_network_endpoint_group.serverless_neg.id
        },
      ]
    }
  }
}
