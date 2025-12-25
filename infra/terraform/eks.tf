module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.0.2"

  name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}
