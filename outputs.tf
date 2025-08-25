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
