region           = "us-east-1"
ECR_Name         = "GitOps_ECR"
Network_VPC_Name = "EKS_VPC"
Network_VPC_CIDR = "10.0.0.0/16"
Public_Subnets = {
  Public_Subnet1 = {
    Subnet_CIDR = "10.0.1.0/24"
    Subnet_AZ   = "us-east-1a"
  }
  Public_Subnet2 = {
    Subnet_CIDR = "10.0.2.0/24"
    Subnet_AZ   = "us-east-1b"
  }
  Public_Subnet3 = {
    Subnet_CIDR = "10.0.3.0/24"
    Subnet_AZ   = "us-east-1c"
  }
}
Private_Subnets = {
  Private_Subnet1 = {
    Subnet_CIDR = "10.0.4.0/24"
    Subnet_AZ   = "us-east-1a"
  }
  Private_Subnet2 = {
    Subnet_CIDR = "10.0.5.0/24"
    Subnet_AZ   = "us-east-1b"
  }
  Private_Subnet3 = {
    Subnet_CIDR = "10.0.6.0/24"
    Subnet_AZ   = "us-east-1c"
  }
}