resource "kubernetes_secret" "repositories" {
  for_each = var.argocd_bootstrap_repositories
  metadata {
    name      = each.key
    namespace = var.argocd_bootstrap_namespace
    labels    = {
      "argocd.argoproj.io/secret-type" = "repository" 
    }      
  }
  data = {
    url = each.value["url"]
  }
  type = "Opaque"
}

resource "kubernetes_secret" "repostiory_credentials" {
  metadata {
    name      = "private-repo-creds"
    namespace = var.argocd_bootstrap_namespace
    labels    = {
      "argocd.argoproj.io/secret-type" = "repo-creds" 
    }      
  }
  data = {
    url = var.arogcd_bootstrap_github
    sshPrivateKey = var.arogcd_bootstrap_sshkey
  }
  type = "Opaque"
}

resource "kubectl_manifest" "bootstrap_app" {
  yaml_body = templatefile("${path.module}/templates/bootstrap-app.yml", {
    namespace  = var.argocd_bootstrap_namespace
  })
}