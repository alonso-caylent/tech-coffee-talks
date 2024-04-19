module "app_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.2.0"

  name = var.name

  additional_policy_arns = {
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
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = "*"
        Condition = {
          "StringEquals" = {
            "secretsmanager:ResourceTag/kubernetes-namespace" = "$${aws:PrincipalTag/kubernetes-namespace}",
            "secretsmanager:ResourceTag/eks-cluster-name" = "$${aws:PrincipalTag/eks-cluster-name}"
          }
        }
      },
    ]
  })

  tags = var.tags
}
