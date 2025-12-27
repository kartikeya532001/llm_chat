module "eks_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.39.0"

  role_name = "${var.cluster_name}-eks-role"
  cluster_autoscaler_cluster_names = [var.cluster_name]
  

  attach_cluster_autoscaler_policy = true
}
