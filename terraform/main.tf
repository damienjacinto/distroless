locals {
  region                    = "europe-central2"
  project_id                = "distroless-329216"
  gcp_auth_file             = "../auth/terraform.json"
  arogcd_auth_file          = "../auth/argocd.json"
  argocd_sshkey             = "../auth/sshkey"
  traefik_chart_version     = "9.19.0"
  certmanager_chart_version = "v1.5.4"
  email                     = "djacinto@peaks.fr"
  traefik_domain            = "distroless.ddns.net"
  argocd_domain             = "argocd-distroless.ddns.net"
  github_root               = "git@github.com:damienjacinto"
  repositories              = {
    bootstrap = {
      url  = "git@github.com:damienjacinto/distroless-argocd-bootstrap-app.git"
    },
    apps = {
      url  = "git@github.com:damienjacinto/distroless-argocd-app.git"
    }
  }
}

module "vpc" {
  source     = "./modules/vpc"
  region     = local.region
  project_id = local.project_id
}

module "gke" {
  source                      = "./modules/gke"
  project_id                  = local.project_id
  region                      = local.region
  gke_preemptible             = true
  gke_network_name            = module.vpc.network
  gke_subnet_name             = module.vpc.public_subnetwork
  gke_subnet_secondary_name   = module.vpc.public_subnetwork_secondary_range_name
  gke_services_secondary_name = module.vpc.public_services_secondary_range_name
  gke_enable_kubernetes_alpha = true
  public_network_tag          = module.vpc.public
  private_network_tag         = module.vpc.private
}

module "certmanager" {
  source                             = "./modules/certmanager"
  certmanager_cluster_host           = module.gke.cluster_host
  certmanager_cluster_ca_certificate = module.gke.ca_certificate
  certmanager_chart_version          = local.certmanager_chart_version
  certmanager_email                  = local.email
}

module "traefik" {
  source                         = "./modules/traefik"
  traefik_cluster_host           = module.gke.cluster_host
  traefik_cluster_ca_certificate = module.gke.ca_certificate
  traefik_chart_version          = local.traefik_chart_version
  traefik_domain                 = local.traefik_domain
  traefik_ingress_class          = module.certmanager.ingress_class
  traefik_issuer_name            = module.certmanager.clusterissuer_name
}

module "kpack" {
  source                       = "./modules/kpack"
  kpack_cluster_host           = module.gke.cluster_host
  kpack_cluster_ca_certificate = module.gke.ca_certificate
}

module "argocd" {
  source                            = "./modules/argocd"
  argocd_cluster_host               = module.gke.cluster_host
  argocd_cluster_ca_certificate     = module.gke.ca_certificate
  argocd_github_oauth_client_id     = jsondecode(file(local.arogcd_auth_file)).clientID
  argocd_github_oauth_client_secret = jsondecode(file(local.arogcd_auth_file)).clientSecret     
  argocd_github_oauth_organization  = jsondecode(file(local.arogcd_auth_file)).organization
  argocd_github_admin_user_email    = jsondecode(file(local.arogcd_auth_file)).adminEmail
  argocd_issuer_name                = module.certmanager.clusterissuer_name
  argocd_domain                     = local.argocd_domain  
}

module "argocd-bootstrap" {
  source                                  = "./modules/argocd-bootstrap"
  argocd_bootstrap_cluster_host           = module.gke.cluster_host
  argocd_bootstrap_cluster_ca_certificate = module.gke.ca_certificate 
  argocd_bootstrap_namespace              = module.argocd.argocd_namespace
  arogcd_bootstrap_sshkey                 = file(local.argocd_sshkey)
  arogcd_bootstrap_github                 = local.github_root
  argocd_bootstrap_repositories           = local.repositories
}