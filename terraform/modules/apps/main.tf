apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: bootstrap-app
  namespace: ${local.argocd_namespace}
spec:
  destination:
    namespace: ${local.argocd_namespace}
    server: https://kubernetes.default.svc
  project: default
  source:
    helm:
      valueFiles:
      - bootstrap_app.${var.finalcad_environment}.${var.finalcad_region}.values.yaml
    path: ${var.finalcad_environment}/${var.finalcad_region}
    repoURL: https://github:${local.github_svc_account_token}@github.com/FinalCAD/eks-argocd-bootstrap-app.git
    targetRevision: HEAD
  syncPolicy:
    automated: {}