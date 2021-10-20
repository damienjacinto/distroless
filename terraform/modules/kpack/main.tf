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
