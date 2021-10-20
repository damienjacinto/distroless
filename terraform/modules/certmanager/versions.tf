terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.5"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7"
    }
  }
  required_version = "~> 1.0"
}
