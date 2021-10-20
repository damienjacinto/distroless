output "clusterissuer_name" {
  value       = var.certmanager_clusterissuer_name
  description = "ClusterIssuer name"
}

output "ingress_class" {
  value       = var.certmanager_ingress_class
  description = "Ingress class with ssl"
}

output "certmanager_issuer_account_key" {
  value       = var.certmanager_issuer_account_key
  description = "Secret key for issuer"
}
