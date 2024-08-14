# Create a custom VPC network
resource "google_compute_network" "vpc_network" {
  project = var.project_id
  name = var.network_name
  auto_create_subnetworks = false
}

# Create a subnet for the GKE cluster
resource "google_compute_subnetwork" "gke_subnet" {
  project = var.project_id
  name = var.subnet_name
  ip_cidr_range = "10.10.0.0/24"
  region = var.region
  network = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

# Enable Private Google Access for the subnet
resource "google_compute_subnetwork_iam_member" "private_access" {
  project = var.project_id
  region = var.region
  subnetwork = google_compute_subnetwork.gke_subnet.id
  role = "roles/compute.networkUser"
  member = "serviceAccount:service-${var.project_id}@gcp-sa-servicenetworking.iam.serviceAccount.com"
}

# Create a Cloud Router for Cloud NAT
resource "google_compute_router" "router" {
  project = var.project_id
  name = "${var.network_name}-router"
  region = var.region
  network = google_compute_network.vpc_network.id
}

# Create a Cloud NAT configuration
resource "google_compute_router_nat" "nat" {
  project = var.project_id
  name = "${var.network_name}-nat"
  region = var.region
  router = google_compute_router.router.name
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# Firewall rules
resource "google_compute_firewall" "allow_ssh" {
  project = var.project_id
  name = "${var.network_name}-allow-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["gke-nodes"]
}

resource "google_compute_firewall" "allow_icmp" {
  project = var.project_id
  name = "${var.network_name}-allow-icmp"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["gke-nodes"]
}

resource "google_compute_firewall" "allow_internal" {
 project = var.project_id
 name = "${var.network_name}-allow-internal"
 network = google_compute_network.vpc_network.name
 allow {
   protocol = "tcp"
   ports = ["0-65535"]
 }
 allow {
   protocol = "udp"
   ports = ["0-65535"]
 }
 allow {
   protocol = "icmp"
 }
 source_ranges = ["10.10.0.0/24"]
 target_tags = ["gke-nodes"]
}

# Outputs
output "network_name" {
  value = google_compute_network.vpc_network.name
}

output "subnet_name" {
  value = google_compute_subnetwork.gke_subnet.name
}