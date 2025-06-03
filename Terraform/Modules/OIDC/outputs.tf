output "OIDC_URL" {
  value       = replace(data.aws_eks_cluster.EKS.identity[0].oidc[0].issuer, "https://", "")
  description = "EKS OIDC Provider URL (without https://)"
}
