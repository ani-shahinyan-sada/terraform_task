output "network" {
  description = "The VPC resource being created"
  value       = module.vpc.network
}

output "network_id" {
  description = "The ID of the VPC being created"
  value       = module.vpc.network_id
}

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.vpc.network_name
}

output "network_self_link" {
  description = "The URI of the VPC being created"
  value       = module.vpc.network_self_link
}

output "project_id" {
  description = "VPC project id"
  value       = module.vpc.project_id
}

output "artifact_id" {
  description = "an identifier for the resource"
  value       = module.artifact_registry.artifact_id
}

output "artifact_name" {
  description = "an identifier for the resource"
  value       = module.artifact_registry.artifact_name
}
output "create_time" {
  description = "The time when the repository was created."
  value       = module.artifact_registry.create_time
}
output "update_time" {
  description = "The time when the repository was last updated."
  value       = module.artifact_registry.update_time
}

output "instance_self_link"{
  description = "instance_self_link"
  value = module.mysql-db.instance_self_link
}

output "firewall_rules"{
  description = "The created firewall rule resources"
  value = module.firewall_rules.firewall_rules
}	

output "firewall_rules_ingress_egress"{
  description = "The created firewall ingress/egress rule resources"
  value = module.firewall_rules.firewall_rules.firewall_rules_ingress_egress
}	

