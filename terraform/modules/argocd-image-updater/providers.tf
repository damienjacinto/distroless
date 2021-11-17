data "google_client_config" "current" {
}

provider "kubectl" {
  host                   = var.argocd_image_updater_cluster_host
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(var.argocd_image_updater_cluster_ca_certificate)
  load_config_file       = false
}

provider "kubernetes" {
  host                   = var.argocd_image_updater_cluster_host
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(var.argocd_image_updater_cluster_ca_certificate)
}