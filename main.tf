provider "google" {
 project = var.project_id
 region  = var.region
}

# Network module
module "network" {
 source = "./modules/network"
 project_id = var.project_id
 network_name = var.network_name
 subnet_name = var.subnet_name
 region = var.region
}

# GKE cluster module
module "gke_cluster" {
 source = "./modules/gke"
 project_id = var.project_id
 name = var.cluster_name
 location = var.region
 network_name = module.network.network_name
 subnetwork_name = module.network.subnet_name
 node_pool_name = var.node_pool_name
 machine_type = var.machine_type
 node_count = var.node_count
 min_node_count = var.min_node_count
 max_node_count = var.max_node_count
}