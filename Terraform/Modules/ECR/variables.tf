variable "Name" {
  type = string
}

variable "EKS_NG_Role_Name" {
  description = "EKS node role name to attach ECR access"
  type        = string
}