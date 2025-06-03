module "VPC" {
  source          = "./Modules/Network"
  VPC_Name        = var.Network_VPC_Name
  VPC_CIDR        = var.Network_VPC_CIDR
  Public_Subnets  = var.Public_Subnets
  Private_Subnets = var.Private_Subnets
}

module "EKS_Cluster" {
  source          = "./Modules/EKS"
  Cluster_Subnets = values(module.VPC.PrivSubID)
}

module "ECR" {
  source = "./Modules/ECR"
  Name = var.ECR_Name
  EKS_NG_Role_Name = module.EKS_Cluster.NG_Role_Name
}

module "EBS_CSI_Driver" {
  source = "./Modules/EBS_CSI_Addon"
  EKS_Cluster_Name = module.EKS_Cluster.Cluster_Name
  aws_account_id = var.aws_account_id
  OIDC_URL = module.OIDC.OIDC_URL
}

module "OIDC" {
  source           = "./Modules/OIDC"
  EKS_Cluster_Name = module.EKS_Cluster.Cluster_Name
  depends_on       = [module.EKS_Cluster]
}