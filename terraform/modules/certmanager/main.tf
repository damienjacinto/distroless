resource "kubernetes_namespace" "certmanager" {
  metadata {
    name = "certmanager"
  }
}

resource "helm_release" "certmanager" {
  name       = "certmanager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  version    = var.certmanager_chart_version
  namespace  = kubernetes_namespace.certmanager.metadata.0.name
  values = [<<EOF
    installCRDs: true
EOF
]
}

# Wait for helm operator to install certmanager crd (no data for crd at this moment in the kubernetes provider)
resource "time_sleep" "wait_60_seconds" {
  depends_on      = [helm_release.certmanager]
  create_duration = "60s"
}

resource "kubectl_manifest" "certmanager_issuer" {
  depends_on = [time_sleep.wait_30_seconds]
  yaml_body  = templatefile("${path.module}/templates/clusterissuer.yml", {
    namespace        = kubernetes_namespace.certmanager.metadata[0].name
    name             = var.certmanager_clusterissuer_name
    email            = var.certmanager_email
    issuerAccountKey = var.certmanager_issuer_account_key
    ingressClass     = var.certmanager_ingress_class
  })
}

