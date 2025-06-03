#-------------------------------------------------------------------#
#----------------------------- ECR ---------------------------------#
#-------------------------------------------------------------------#
resource "aws_ecr_repository" "ECR" {
  name                 = var.Name
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

#-------------------------------------------------------------------#
#----------------------------- Policies ----------------------------#
#-------------------------------------------------------------------#

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle" {
  repository = aws_ecr_repository.ECR.name
  policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Expire images older than 15 days",
        "selection" : {
          "tagStatus" : "untagged",
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : 15
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })

}

resource "aws_iam_role_policy" "EKS_NG_ECR_Policy" {
  name = "eks-ecr-access"
  role = var.EKS_NG_Role_Name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          # pull action 
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:ListImages",
          # push actions
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          # additional action for managing the repo
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
        ],
        Resource = "*"
      }
    ]
  })
}
