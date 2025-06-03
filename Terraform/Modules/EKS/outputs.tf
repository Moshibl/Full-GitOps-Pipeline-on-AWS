output "NG_Role_Name" {
  description = "the name of EKS Node Group IAM Role"
  value = aws_iam_role.NG_Role.name
}

output "Cluster_Name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.EKS.name
}