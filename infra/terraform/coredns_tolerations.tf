resource "null_resource" "coredns_tolerations" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<EOT
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coredns
  namespace: kube-system
spec:
  template:
    spec:
      tolerations:
      - key: warm-pool
        operator: Equal
        value: "true"
        effect: NoSchedule
      - key: spot
        operator: Equal
        value: "true"
        effect: PreferNoSchedule
EOF
EOT
    environment = {
      KUBECONFIG = module.eks.kubeconfig_path
    }
  }
}
