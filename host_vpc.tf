resource "google_compute_shared_vpc_host_project" "host" {
  project = var.host_project_id
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 11.1"

  project_id   = var.host_project_id
  network_name = var.network_name
  subnets = [
    {
      #this is the host vpc subnet
      subnet_name   = "subnet-01"
      subnet_ip     = var.host_ip_range
      subnet_region = var.region
    },
    {
      #this is the service vpc subnet
      subnet_name   = "subnet-02"
      subnet_ip     = var.service_ip_range
      subnet_region = var.region
    }
  ]
}
