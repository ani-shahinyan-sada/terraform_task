variable "db_name" {
  description = "the name of the db"
  type        = string
}

variable "host_project_id" {
  description = "the ID of the host project"
  type        = string
}

variable "service_project_id" {
  description = "the ID of the service project"
  type        = string
}

variable "region" {
  description = "the region where all the resources should be deployed"
  type        = string
}

variable "zone" {
  description = "the zone where all the resources should be deployed"
  type        = string
}

variable "lb_ip_range" {
  description = "the ip range to be used by the load balancer"
}

variable "image" {
  description = "the image used in cloudrun"
}
variable "ssl_cert" {
  description = "the ssl certificate for secure connection"
}

variable "network_name" {
  description = "the name of the vpc network"
}

variable "host_ip_range" {
  description = "the cidr range of the host network"
}

variable "service_ip_range" {
  description = "the cidr range of the service network"
}

variable "repo_name" {
  description = "the repository to be created in artifact registry"
}

variable "lb_name" {
  description = "load balancer name"
}

variable "service_account_email" {
  description = "sthe service account that will create all the resources"
}

variable "instance_tier" {
  description = " the tier of the database instance"
  type        = string
}

variable "service_port_name" {
  description = "the name of the service port for cloudrun"
  type        = string
}

variable "user_password"{
  description = "the password of the database user"
}
