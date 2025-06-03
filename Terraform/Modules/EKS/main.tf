#-------------------------------------------------------------------#
#----------------------------- EKS ---------------------------------#
#-------------------------------------------------------------------#

resource "aws_eks_cluster" "EKS" {
  name = "EKS"

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  role_arn = aws_iam_role.Cluster_Role.arn
  version  = "1.31"

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = var.Cluster_Subnets
  }

  tags = {
    Name        = "EKS Cluster"
    Environment = "Deployment"
  }
  depends_on = [
    aws_iam_role_policy_attachment.Cluster_AmazonEKSClusterPolicy,
  ]
}

#-------------------------------------------------------------------#
#---------------------- EKS Role And Attachment --------------------#
#-------------------------------------------------------------------#


resource "aws_iam_role" "Cluster_Role" {
  name = "Cluster_Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  tags = {
  tag-key = "eks_cluster-role"
}
}

resource "aws_iam_role_policy_attachment" "Cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.Cluster_Role.name
}

#-------------------------------------------------------------------#
#----------------------------- Node Group --------------------------#
#-------------------------------------------------------------------#

resource "aws_eks_node_group" "EKS_NG" {
  cluster_name    = aws_eks_cluster.EKS.name
  node_group_name = "EKS_NG"
  node_role_arn   = aws_iam_role.NG_Role.arn
  subnet_ids      = var.Cluster_Subnets

  instance_types = ["t3.medium"]
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  scaling_config {
    max_size     = 3
    desired_size = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = "EKS Node Group"
    Environment = "Deployment"
  }

  depends_on = [
    aws_iam_role_policy_attachment.NG-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.NG-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.NG-AmazonEC2ContainerRegistryReadOnly,
  ]
}

#-------------------------------------------------------------------#
#----------------------- NG Role And Attachment --------------------#
#-------------------------------------------------------------------#

resource "aws_iam_role" "NG_Role" {
  name = "NG_Role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "NG-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.NG_Role.name
}

resource "aws_iam_role_policy_attachment" "NG-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.NG_Role.name
}

resource "aws_iam_role_policy_attachment" "NG-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.NG_Role.name
}