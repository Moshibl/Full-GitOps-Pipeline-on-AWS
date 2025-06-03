variable "region" {
  type = string
}

variable "Network_VPC_Name" {
  type = string
}

variable "Network_VPC_CIDR" {
  type = string
}

variable "Public_Subnets" {
  type = map(object({
    Subnet_CIDR = string
    Subnet_AZ   = string
  }))
}

variable "Private_Subnets" {
  type = map(object({
    Subnet_CIDR = string
    Subnet_AZ   = string
  }))
}

variable "ECR_Name" {
  type = string
}

variable "aws_account_id" {
  type = string
}
