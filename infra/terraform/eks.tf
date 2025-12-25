module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.0.2"

  name    = var.cluster_name
  kubernetes_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  endpoint_public_access = true
  cluster_service_cidr = "10.0.200.0/24"  # example CIDR for cluster services


  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}
