terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.31.0"

    }
  }
}

provider "google" {
  alias   = "project1"
  project = var.host_project_id
  region  = var.region
}

provider "google" {
  alias   = "project2"
  project = var.service_project_id
  region  = var.region
}


