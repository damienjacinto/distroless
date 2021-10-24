variable "argocd_bootstrap_cluster_host" {
  type    = string
  default = ""
}

variable "argocd_bootstrap_cluster_ca_certificate" {
  type    = string
  default = ""
}

variable "argocd_bootstrap_namespace" {
  type    = string
  default = ""
}

variable "arogcd_bootstrap_sshkey" {
  type    = string
  default = ""
}

variable "arogcd_bootstrap_github" {
  type    = string
  default = ""
}

variable "argocd_bootstrap_repositories" {
  type = map(object({
    url  = string
  }))
}