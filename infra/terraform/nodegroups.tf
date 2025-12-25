# ======================================
# EKS Cluster
# ======================================
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = "var.cluster_name"
  cluster_version = "1.30"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  # Optional: cluster logging, tags, etc.
  tags = {
    Environment = "prod"
    Project     = "llm-chat"
  }

  # ======================================
  # Node Groups
  # ======================================
  node_groups = {
    # ----------------------
    # Warm Pool (ON_DEMAND)
    # ----------------------
    warm = {
      desired_capacity       = 1
      min_capacity           = 1
      max_capacity           = 1
      instance_type          = "r6g.large"
      capacity_type          = "ON_DEMAND"
      disk_size              = 100

      iam_attach_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]

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

      ssh_allow      = true
      ssh_public_key = "Testing"

      tags = {
        Name = "cpu-warm-workers"
      }
    }

    # ----------------------
    # Spot Pool (SPOT)
    # ----------------------
    spot = {
      desired_capacity       = 0
      min_capacity           = 0
      max_capacity           = 3
      instance_type          = "r6g.xlarge"
      capacity_type          = "SPOT"
      disk_size              = 100

      iam_attach_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]

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

      ssh_allow      = true
      ssh_public_key = "Testing"

      tags = {
        Name = "cpu-spot-workers"
      }
    }
  }
}
