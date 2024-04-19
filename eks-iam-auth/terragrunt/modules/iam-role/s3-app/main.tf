module "app_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.2.0"

  name = var.name

  additional_policy_arns = {
    AmazonS3ReadOnlyAccess = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    additional             = aws_iam_policy.additional.arn
  }

  associations = {
    ex-one = {
      cluster_name    = var.cluster_name
      namespace       = var.namespace
      service_account = var.service_account
    }
  }

  tags = var.tags
}

################################################################################
# Supporting Resources
################################################################################

resource "aws_iam_policy" "additional" {
  name        = "${var.name}-additional"
  description = "Additional test policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = var.tags
}
