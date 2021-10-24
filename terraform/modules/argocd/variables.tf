variable "argocd_cluster_host" {
  type    = string
  default = ""
}
variable "argocd_cluster_ca_certificate" {
  type    = string
  default = ""
}

variable "argocd_github_oauth_client_id" {
  type    = string
  default = ""
}

variable "argocd_github_oauth_client_secret" {
  type    = string
  default = "" 
}

variable "argocd_github_oauth_organization" {
  type    = string
  default = "" 
}

variable "argocd_github_admin_user_email" {
  type    = string
  default = ""
}

variable "argocd_domain" {
  type    = string
  default = ""
}

variable "argocd_version" {
  type    = string
  default = "3.26.2"
} 

variable "argocd_issuer_name" {
  type    = string
  default = ""
}