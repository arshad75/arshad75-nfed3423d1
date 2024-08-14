# Create a GKE cluster
resource "google_container_cluster" "primary" {
  project = var.project_id
  name = var.name
  location = var.location

  # Networking
  network = var.network_name
  subnetwork = var.subnetwork_name
  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = true
    master_ipv4_cidr_block = "172.16.0.0/28"
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0"
      display_name = "All networks"
    }
  }

  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Node pool configuration
  node_pool {
    name = var.node_pool_name
    initial_node_count = var.node_count
    autoscaling {
      enabled = true
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
    management {
      auto_repair = true
      auto_upgrade = true
    }
    node_config {
      machine_type = var.machine_type
      disk_size_gb = 100
      disk_type = "pd-standard"
      oauth_scopes = [
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/trace.append",
      ]
      # Enable Shielded GKE Nodes
      shielded_instance_config {
        enable_secure_boot = true
        enable_integrity_monitoring = true
      }
      # Configure metadata
      metadata = {
        disable-legacy-endpoints = "true"
      }
      # Enable VPC-native traffic
      workload_metadata_config {
        mode = "GKE_METADATA_SERVER"
      }
    }
  }

  # Release channel
  release_channel {
    channel = "REGULAR"
  }

  # Disable default node pool
  remove_default_node_pool = true

  # Enable cluster autoscaling
  vertical_pod_autoscaling {
    enabled = true
  }

  # Logging and monitoring
  logging_service = "logging.googleapis.com/logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/monitoring.googleapis.com/kubernetes-engine"
}