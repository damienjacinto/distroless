locals {
  region                    = "europe-central2"
  project_id                = "distroless-329216"
  gcp_auth_file             = "../auth/terraform.json"
  traefik_chart_version     = "9.19.0"
  certmanager_chart_version = "v1.5.4"
  email                     = "djacinto@peaks.fr"
  domain                    = "distroless.ddns.net"
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
  traefik_domain                 = local.domain
  traefik_ingress_class          = module.certmanager.ingress_class
  traefik_issuer_name            = module.certmanager.clusterissuer_name
}

module "kpack" {
  source                       = "./modules/kpack"
  kpack_cluster_host           = module.gke.cluster_host
  kpack_cluster_ca_certificate = module.gke.ca_certificate
}
