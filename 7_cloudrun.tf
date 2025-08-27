# module "cloud_run" {
#   source                = "GoogleCloudPlatform/cloud-run/google"
#   version               = "~> 0.12"
#   service_name          = var.network_name
#   project_id            = var.service_project_id
#   location              = var.region
#   image                 = "us-west1-docker.pkg.dev/ani-proj-2/terraform-task/app:latest"
#   service_account_email = var.service_account_email

#   vpc_access= {
#     egress = "all-traffic"

#   }

#   env_vars = [
#     {
#       name  = "DB_CONNECTION"
#       value = module.mysql-db.instance_connection_name
#     }
#   ]
# }


resource "google_cloud_run_v2_service" "default" {
  provider = google-beta
  name     = "python-app-cloudrun"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  project = var.service_project_id
  template {
    containers {
      image = var.image
    }


    vpc_access {
      network_interfaces {
        network    = module.vpc.network_name
        subnetwork = module.vpc.subnets_names[0]

      }
      egress = "PRIVATE_RANGES_ONLY"
    }

  }

}
