data "google_client_config" "current" {
}

provider "kubectl" {
  host                   = var.kpack_cluster_host
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(var.kpack_cluster_ca_certificate)
  load_config_file       = false
}

provider "kubernetes" {
  host                   = var.kpack_cluster_host
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(var.kpack_cluster_ca_certificate)
}