data "google_client_config" "current" {
}

provider "kubernetes" {
  host                   = var.traefik_cluster_host
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(var.traefik_cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = var.traefik_cluster_host
    token                  = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(var.traefik_cluster_ca_certificate)
  }
}

provider "kubectl" {
  host                   = var.traefik_cluster_host
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(var.traefik_cluster_ca_certificate)
  load_config_file       = false
}
