resource "kubernetes_manifest" "coredns_tolerations" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "coredns"
      namespace = "kube-system"
    }
    spec = {
      template = {
        spec = {
          tolerations = [
            {
              key      = "warm-pool"
              operator = "Equal"
              value    = "true"
              effect   = "NoSchedule"
            },
            {
              key      = "spot"
              operator = "Equal"
              value    = "true"
              effect   = "PreferNoSchedule"
            }
          ]
        }
      }
    }
  }
}
