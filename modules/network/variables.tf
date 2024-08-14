variable "project_id" {
  type = string
  description = "GCP project ID"
}

variable "network_name" {
  type = string
  description = "Name of the VPC network"
}

variable "subnet_name" {
  type = string
  description = "Name of the GKE subnet"
}

variable "region" {
 type = string
 description = "GCP region for the subnet"
}