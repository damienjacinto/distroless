resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  autoscaling {
    max_node_count = 3
    min_node_count = 1
  }

  management {
    auto_repair  = false
    auto_upgrade = false
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]

    labels = {
      env = var.project_id
    }

    preemptible  = var.gke_preemptible
    disk_size_gb = 10
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke", var.public_network_tag]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}
