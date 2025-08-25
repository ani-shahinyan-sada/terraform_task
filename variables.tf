variable "db_name" {
  description = "the name of the db"
}

variable "authorized_networks" {
  description = "networks allowed to connect to the db"
}

variable "host_project_id" {
  description = "the ID of the host project"
}

variable "service_project_id" {
  description = "the ID of the service project"
}

variable "region" {}

variable "zone" {}

variable "lb_ip_range" {}


variable "ssl_cert" {
  description = "the id of the service account in service project"
}

variable "network_name" {
  description = "the name of the vpc network"
}

variable "host_ip_range" {
  description = "host cidr range"
}

variable "service_ip_range" {
  description = "service cidr range"
}

variable "repo_name" {
  description = "registry repo name"
}

variable "lb_name" {
  description = "load balancer name"
}

variable "service_account_email" {
  description = "service account for tasks"
}

variable "instance_tier" {
  type        = string
  description = " Tier of the DB Instance"
}

variable "service_port_name" {
  description = "the name of the service port"

}
