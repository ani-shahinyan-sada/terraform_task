module "gcs_buckets" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 11.0"
  project_id  = var.service_project_id
  names = ["first", "second"]
  prefix = "anitask"
  versioning = {
    first = true
  }
}