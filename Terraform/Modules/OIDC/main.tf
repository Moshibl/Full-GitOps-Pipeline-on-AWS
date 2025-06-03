data "aws_eks_cluster" "EKS" {
  name = var.EKS_Cluster_Name
}

data "aws_eks_cluster_auth" "EKS" {
  name = var.EKS_Cluster_Name
}

data "tls_certificate" "EKS_Cluster" {
  url = data.aws_eks_cluster.EKS.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "EKS" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.EKS_Cluster.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.EKS.identity[0].oidc[0].issuer
}