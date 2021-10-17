locals {
  region        = "europe-central2"
  project_id    = "distroless-329216"
  gcp_auth_file = "../auth/terraform.json"
}

module "vpc" {
  source     = "./module/vpc"
  region     = local.region
  project_id = local.project_id
}

module "gke" {
  source                      = "./module/gke"
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
