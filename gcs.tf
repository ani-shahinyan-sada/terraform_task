module "bucket" {
  source     = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version    = "~> 11.0"
  name       = "edge-config-bucket"
  project_id = var.service_project_id
  location   = "us-east1"
}
