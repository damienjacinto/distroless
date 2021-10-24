output "argocd_namespace" {
  value       = kubernetes_namespace.argocd.metadata.0.name
  description = "Return argocd namespace"
}