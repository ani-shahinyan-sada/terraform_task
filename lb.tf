module "lb-http" {
  source  = "terraform-google-modules/lb-http/google//modules/serverless_negs"
  version = "~> 12.0"

  name    = var.lb_name
  project = var.service_project_id 
  
  backends = {
    default = {
      description = "Cloud Run backend"
      groups = [
        {
          group = google_compute_region_network_endpoint_group.serverless_neg.id
        }
      ]
      enable_cdn = false
      
      iap_config = {
        enable = false
      }
      log_config = {
        enable = true
      }
    }
  }
}