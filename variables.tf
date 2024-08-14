variable "project_id" {
  type = string
  description = "GCP project ID"
}

variable "region" {
  type = string
  description = "GCP region"
  default = "us-central1"
}

variable "zone" {
  type = string
  description = "GCP zone within the selected region"
  default = "us-central1-a"
}

variable "cluster_name" {
  type = string
  description = "Name of the GKE cluster"
}

variable "network_name" {
  type = string
  description = "Name of the VPC network"
}

variable "subnet_name" {
  type = string
  description = "Name of the GKE subnet"
}

variable "node_pool_name" {
  type = string
  description = "Name of the GKE node pool"
}

variable "machine_type" {
  type = string
  description = "Machine type for the GKE nodes"
  default = "n1-standard-1"
}

variable "node_count" {
  type = number
  description = "Initial number of nodes in the node pool"
  default = 3
}

variable "min_node_count" {
 type = number
 description = "Minimum number of nodes for autoscaling"
 default = 1
}

variable "max_node_count" {
 type = number
 description = "Maximum number of nodes for autoscaling"
 default = 5
}