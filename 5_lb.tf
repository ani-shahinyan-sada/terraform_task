module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 12.0"
  project = var.service_project_id
  name    = "httplbforapp"
  ssl     = true
  backends = {
    default = {
      protocol   = "HTTP"
      port_name  = var.service_port_name
      enable_cdn = false


      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group = google_compute_region_network_endpoint_group.neg.id
        }
      ]

      iap_config = {
        enable = false
      }
    }
  }
}
