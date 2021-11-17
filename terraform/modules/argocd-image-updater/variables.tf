variable "argocd_image_updater_cluster_host" {
  type    = string
  default = ""
}

variable "argocd_image_updater_cluster_ca_certificate" {
  type    = string
  default = ""
}

variable "argocd_image_updater_registry_password" {
  type    = string
  default = ""
}

variable "argocd_image_updater_namespace" {
  type    = string
  default = ""
}

variable "argocd_image_updater_secretname" {
  type    = string
  default = "registry-credential"
}

variable "argocd_image_updater_registry" {
  type    = string
  default = "https://europe-central2-docker.pkg.dev" 
}