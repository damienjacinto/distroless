locals {
  argocd_image_updater_ressources = "https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml"
  yamls = [for data in split("---", data.http.argocd_image_updater.body): data]
}

data "http" "argocd_image_updater" {
  url = local.argocd_image_updater_ressources
  request_headers = {
    Accept = "text/plain"
  }
}

resource "kubectl_manifest" "argocd_image_updater" {
  for_each = toset(local.yamls)
  yaml_body = each.value
  override_namespace = var.argocd_image_updater_namespace
}

resource "kubectl_manifest" "argocd_image_updater_config" {
  yaml_body = templatefile("${path.module}/templates/argocd-image-updater-config.yml", {
    namespace  = var.argocd_image_updater_namespace
    registry   = var.argocd_image_updater_registry
    credential = var.argocd_image_updater_secretname
  })
  depends_on = [kubectl_manifest.argocd_image_updater]
}

resource "kubernetes_secret" "registry_credential" {
  metadata {
    name = var.argocd_image_updater_secretname
    namespace = var.argocd_image_updater_namespace
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.argocd_image_updater_registry}" = {
          auth = "${base64encode("_json_key:${var.argocd_image_updater_registry_password}")}",
          username = "_json_key",
          password = "${var.argocd_image_updater_registry_password}"
        }
      }
    })
  }
  type = "kubernetes.io/dockerconfigjson"
}