locals {
  kpack_ressources = "https://github.com/pivotal/kpack/releases/download/v0.4.0/release-0.4.0.yaml"
  yamls = [for data in split("---", data.http.kpack.body): data]
}

data "http" "kpack" {
  url = local.kpack_ressources
  request_headers = {
    Accept = "text/plain"
  }
}

resource "kubectl_manifest" "kpack" {
  for_each = toset(local.yamls)
  yaml_body = each.value
}

resource "kubectl_manifest" "kpack_store" {
  yaml_body = templatefile("${path.module}/templates/store.yml", {
    namespace = "kpack"
  })
  depends_on = [kubectl_manifest.kpack]
}

resource "kubectl_manifest" "kpack_stack" {
  yaml_body = templatefile("${path.module}/templates/stack.yml", {
    namespace = "kpack"
  })
  depends_on = [kubectl_manifest.kpack]
}


resource "kubectl_manifest" "kpack_builder" {
  yaml_body = templatefile("${path.module}/templates/builder.yml", {
    namespace = "kpack"
  })
  depends_on = [kubectl_manifest.kpack]
}

resource "kubernetes_secret" "registry_credential" {
  metadata {
    name = "registry-credential"
    namespace = "kpack"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://europe-central2-docker.pkg.dev" = {
          auth = "${base64encode("_json_key:${var.kpack_registry_password}")}",
          username = "_json_key",
          password = "${var.kpack_registry_password}"
        }
      }
    })
  }
  type = "kubernetes.io/dockerconfigjson"
  depends_on = [kubectl_manifest.kpack]
}

resource "kubernetes_service_account" "kpack" {
  metadata {
    name = "kpack"
    namespace = "kpack"
  }
  secret {
    name = "${kubernetes_secret.registry_credential.metadata.0.name}"
  }

  image_pull_secret {
    name = "${kubernetes_secret.registry_credential.metadata.0.name}"
  }
  depends_on = [kubectl_manifest.kpack]
}