# -----------------------------
# AWS provider
# -----------------------------
provider "aws" {
  region = var.aws_region
}

# -----------------------------
# EKS module
# -----------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.0.2"

  name               = var.cluster_name
  kubernetes_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  endpoint_public_access = true

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}

# -----------------------------
# Kubernetes provider (using module outputs)
# -----------------------------
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority[0].data)
  token                  = module.eks.cluster_token
}
