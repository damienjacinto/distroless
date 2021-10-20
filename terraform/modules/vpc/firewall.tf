resource "google_compute_firewall" "public_allow_all_inbound" {
  name = "${var.project_id}-public-allow-ingress"

  project = var.project_id
  network = google_compute_network.vpc.name

  target_tags   = [local.public]
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  priority = "1000"

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "public_restricted_allow_inbound" {

  count = length(var.allowed_public_restricted_subnetworks) > 0 ? 1 : 0

  name = "${ var.project_id}-public-restricted-allow-ingress"

  project = var.project_id
  network = google_compute_network.vpc.name

  target_tags   = [local.public_restricted]
  direction     = "INGRESS"
  source_ranges = var.allowed_public_restricted_subnetworks

  priority = "1000"

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "private_allow_all_network_inbound" {
  name = "${var.project_id}-private-allow-ingress"

  project = var.project_id
  network = google_compute_network.vpc.name

  target_tags = [local.private]
  direction   = "INGRESS"

  source_ranges = [
    google_compute_subnetwork.vpc_subnetwork_public.ip_cidr_range,
    google_compute_subnetwork.vpc_subnetwork_public.secondary_ip_range[0].ip_cidr_range,
    google_compute_subnetwork.vpc_subnetwork_public.secondary_ip_range[1].ip_cidr_range,
    google_compute_subnetwork.vpc_subnetwork_private.ip_cidr_range,
    google_compute_subnetwork.vpc_subnetwork_private.secondary_ip_range[0].ip_cidr_range,
  ]

  priority = "1000"

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "private_allow_restricted_network_inbound" {
  name = "${var.project_id}-allow-restricted-inbound"

  project = var.project_id
  network = google_compute_network.vpc.name

  target_tags = [local.private_persistence]
  direction   = "INGRESS"

  # source_tags is implicitly within this network; tags are only applied to instances that rest within the same network
  source_tags = [local.private, local.private_persistence]

  priority = "1000"

  allow {
    protocol = "all"
  }
}
