resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "helm_release" "traefik" {
  name       = "traefik"
  chart      = "traefik"
  repository = "https://helm.traefik.io/traefik"
  version    = var.traefik_chart_version
  namespace  = kubernetes_namespace.traefik.metadata.0.name

  values = [<<EOF
    deployment:
      kind: DaemonSet
    service:
      type: LoadBalancer
    globalArguments: []
    additionalArguments:
    - "--api.insecure=true"
    - "--providers.kubernetesIngress.ingressClass=${var.traefik_ingress_class}"
EOF
]
}

resource "kubectl_manifest" "ingressroute-dashboard" {
  yaml_body = templatefile("${path.module}/templates/ingressroute-dashboard.yml", {
    namespace = kubernetes_namespace.traefik.metadata.0.name
    dns       = var.traefik_domain
  })
  depends_on = [helm_release.traefik]
}

resource "kubectl_manifest" "certificate-dashboard" {
  yaml_body = templatefile("${path.module}/templates/certificate-dashboard.yml", {
    namespace  = kubernetes_namespace.traefik.metadata.0.name
    dns        = var.traefik_domain
    issuerName = var.traefik_issuer_name
  })
  depends_on = [helm_release.traefik]
}

