
resource "google_compute_subnetwork" "vpc_subnetwork_public" {
  name = "${var.project_id}-subnetwork-public"

  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.self_link

  private_ip_google_access = true
  ip_cidr_range            = cidrsubnet(var.cidr_block, var.cidr_subnetwork_width_delta, 0)

  secondary_ip_range {
    range_name = var.public_subnetwork_secondary_range_name
    ip_cidr_range = cidrsubnet(
      var.secondary_cidr_block,
      var.secondary_cidr_subnetwork_width_delta,
      0
    )
  }

  secondary_ip_range {
    range_name = var.public_services_secondary_range_name
    ip_cidr_range = var.public_services_secondary_cidr_block != null ? var.public_services_secondary_cidr_block : cidrsubnet(
      var.secondary_cidr_block,
      var.secondary_cidr_subnetwork_width_delta,
      1 * (2 + var.secondary_cidr_subnetwork_spacing)
    )
  }
}

resource "google_compute_subnetwork" "vpc_subnetwork_private" {
  name = "${var.project_id}-subnetwork-private"

  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.self_link

  private_ip_google_access = true
  ip_cidr_range = cidrsubnet(
    var.cidr_block,
    var.cidr_subnetwork_width_delta,
    1 * (1 + var.cidr_subnetwork_spacing)
  )

  secondary_ip_range {
    range_name = "private-services"
    ip_cidr_range = var.private_services_secondary_cidr_block != null ? var.private_services_secondary_cidr_block : cidrsubnet(
      var.secondary_cidr_block,
      var.secondary_cidr_subnetwork_width_delta,
      1 * (1 + var.secondary_cidr_subnetwork_spacing)
    )
  }
}
