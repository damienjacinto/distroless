resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name          = "argocd"
  repository    = "https://argoproj.github.io/argo-helm"
  chart         = "argo-cd"
  version       = var.argocd_version
  force_update  = false
  recreate_pods = true
  namespace     = kubernetes_namespace.argocd.metadata.0.name
  wait          = false
  values = [<<EOF
server:
  extraArgs:
  - --insecure
  config:
    admin.enabled: "false"
    url: "https://${var.argocd_domain}"
    dex.config: |
      connectors:
      - type: github
        id: github
        name: GitHub
        config:
          clientID: $dex.github.clientId
          clientSecret: $dex.github.clientSecret
  rbacConfig:
    policy.default: "role:readonly"
    policy.csv: |
      p, role:org-admin, applications, *, */*, allow
      p, role:org-admin, clusters, get, *, allow
      p, role:org-admin, repositories, get, *, allow
      p, role:org-admin, repositories, create, *, allow
      p, role:org-admin, repositories, update, *, allow
      p, role:org-admin, repositories, delete, *, allow
      p, role:image-updater, applications, get, *, allow
      p, role:image-updater, applications, upadte, *, allow
      g, image-updater, role:image-updater
      g, ${var.argocd_github_admin_user_email}, role:org-admin
    scopes: '[email, group]'   
configs:
  secret:
    extra:
      dex.github.clientId: ${var.argocd_github_oauth_client_id}
      dex.github.clientSecret: ${var.argocd_github_oauth_client_secret}
EOF
]
}

resource "kubectl_manifest" "ingressroute-dashboard" {
  yaml_body = templatefile("${path.module}/templates/ingressroute-dashboard.yml", {
    namespace = kubernetes_namespace.argocd.metadata.0.name
    dns       = var.argocd_domain
  })
  depends_on = [helm_release.argocd]
}

resource "kubectl_manifest" "certificate-dashboard" {
  yaml_body = templatefile("${path.module}/templates/certificate-dashboard.yml", {
    namespace  = kubernetes_namespace.argocd.metadata.0.name
    dns        = var.argocd_domain
    issuerName = var.argocd_issuer_name
  })
  depends_on = [helm_release.argocd]
}

