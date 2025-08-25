module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.host_project_id
  network_name = module.vpc.network_name

  rules = [{
    name               = "allow-tcp-ingress"
    direction          = "INGRESS"
    priority           = 1000
    destination_ranges = var.host_ip_range
    #source_ranges           = ["0.0.0.0/0"]
    source_service_accounts = [var.service_account_email]
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22, 3306"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
    }
  ]
}