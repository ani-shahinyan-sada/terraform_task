resource "google_compute_ssl_certificate" "default" {
  name        = "cloud-run-self-signed-cert"
  project     = var.service_project_id
  private_key = file("private-key.pem")
  certificate = file("certificate.pem")

  lifecycle {
    create_before_destroy = true
  }
}

module "lb-http" {
  source           = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version          = "~> 12.0"
  project          = var.service_project_id
  name             = "httplbforapp"
  ssl              = true
  ssl_certificates = [google_compute_ssl_certificate.default.id]
  backends = {
    default = {
      protocol   = "HTTP"
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
