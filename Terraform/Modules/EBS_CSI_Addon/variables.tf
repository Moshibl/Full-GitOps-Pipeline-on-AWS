variable "EKS_Cluster_Name" {
  description = "EKS cluster name"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "OIDC_URL" {
  description = "EKS OIDC Provider URL (without https://)"
  type        = string
}