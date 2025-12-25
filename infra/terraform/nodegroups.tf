# ======================================
# Warm Pool (Always-on, On-Demand)
# ======================================
module "eks_node_group_warm" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.8.4"

  cluster_name    = module.eks.cluster_name
  cluster_version = module.eks.cluster_version
  node_group_name = "cpu-warm"

  subnet_ids = module.vpc.private_subnets

  instance_types = ["r6g.large"]
  capacity_type  = "ON_DEMAND"

  min_size     = 1
  max_size     = 1
  desired_size = 1

  disk_size = 40

  labels = {
    "node-role" = "cpu"
    "pool"      = "warm"
  }

  taints = [
    {
      key    = "warm-pool"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  ]

  ssh_allow = true
  ssh_public_key = "Testing"

  tags = {
    Name = "cpu-warm-workers"
  }

  iam_attach_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

# ======================================
# Spot Nodes (Scale on load)
# ======================================
module "eks_node_group_spot" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.8.4"

  cluster_name    = module.eks.cluster_name
  cluster_version = module.eks.cluster_version
  node_group_name = "cpu-spot"

  subnet_ids = module.vpc.private_subnets

  instance_types = ["r6g.xlarge"]
  capacity_type  = "SPOT"

  min_size     = 0
  max_size     = 3
  desired_size = 0

  disk_size = 40

  labels = {
    "node-role" = "cpu"
    "pool"      = "spot"
  }

  taints = [
    {
      key    = "spot"
      value  = "true"
      effect = "PREFER_NO_SCHEDULE"
    }
  ]

  tags = {
    Name = "cpu-spot-workers"
  }

  iam_attach_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}
