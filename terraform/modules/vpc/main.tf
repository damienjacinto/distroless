locals {
  public              = "public"
  public_restricted   = "public-restricted"
  private             = "private"
  private_persistence = "private-persistence"
}

resource "google_compute_network" "vpc" {
  name                            = "${var.project_id}-vpc"
  auto_create_subnetworks         = "false"
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true
}

resource "google_compute_router" "vpc_router" {
  name = "${var.project_id}-router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.name
}

resource "google_compute_route" "vpc_default_egress" {
  name = "${var.project_id}-router-default-egress"
  project = var.project_id
  network = google_compute_network.vpc.name
  description            = "route through IGW to access internet"
  dest_range             = "0.0.0.0/0"
  next_hop_gateway       = "default-internet-gateway"
}

resource "google_compute_router_nat" "vpc_nat" {
  name = "${var.project_id}-nat"

  project = var.project_id
  region  = var.region
  router  = google_compute_router.vpc_router.name

  nat_ip_allocate_option = "AUTO_ONLY"

  # "Manually" define the subnetworks for which the NAT is used, so that we can exclude the public subnetwork
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnetwork_public.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

