locals {
  argocd-clusters = {
    for cluster_name, cluster_obj in var.k8s_clusters :
    "${cluster_name}-cluster" => {
      name = "${cluster_name}-cluster"
      secrets_data = {
        name   = cluster_name
        server = "https://${cluster_obj.endpoint}"
        config = <<EOF
{
  "execProviderConfig": {
    "command": "argocd-k8s-auth",
    "args": ["${var.env.cloud.name}"],
    "apiVersion": "client.authentication.k8s.io/v1beta1"
  },
  "tlsClientConfig": {
    "insecure": false,
    "caData": "${cluster_obj.ca_certificate}"
  }
}
EOF
      }
      k8s = {
        enabled   = true
        namespace = "argocd"
      }
      annotations = {
      }
      labels = {
        "argocd.argoproj.io/secret-type" = "cluster"
      }
    }
    if cluster_name != "int"
  }
}
