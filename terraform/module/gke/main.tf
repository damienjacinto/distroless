# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.gke_network_name
  subnetwork = var.gke_subnet_name

  enable_kubernetes_alpha = var.gke_enable_kubernetes_alpha
  logging_service         = "none"
  monitoring_service      = "none"

  ip_allocation_policy {
    cluster_secondary_range_name  = var.gke_subnet_secondary_name
    services_secondary_range_name = var.gke_services_secondary_name
  }

  addons_config {
    http_load_balancing {
      disabled = true
    }

    horizontal_pod_autoscaling {
      disabled = true
    }
  }

  lifecycle {
    ignore_changes = [
      # Since we provide `remove_default_node_pool = true`, the `node_config` is only relevant for a valid construction of
      # the GKE cluster in the initial creation. As such, any changes to the `node_config` should be ignored.
      node_config, initial_node_count
    ]
  }
}
