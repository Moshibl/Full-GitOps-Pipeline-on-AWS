resource "aws_eks_addon" "EBS_CSI_Driver" {
  cluster_name = var.EKS_Cluster_Name
  addon_name   = "aws-ebs-csi-driver"
  addon_version = "v1.44.0-eksbuild.1" 

  service_account_role_arn = aws_iam_role.EBS_CSI_Role.arn

  tags = {
    Name = "EBS CSI Driver"
  }

  depends_on = [
    aws_iam_role_policy_attachment.EBS_Role_Attachment
  ]
}
#-----------------------------------------------------------------------#
#---------------------- IAM Role for EBS CSI Driver --------------------#
# ----------------------------------------------------------------------#

resource "aws_iam_role" "EBS_CSI_Role" {
  name = "AmazonEKS_EBS_CSI_DriverRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${var.OIDC_URL}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${var.OIDC_URL}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "EBS_Role_Attachment" {
  role       = aws_iam_role.EBS_CSI_Role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}





