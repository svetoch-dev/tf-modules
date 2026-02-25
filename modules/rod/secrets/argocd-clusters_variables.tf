locals {
  argocd-clusters = {
    for cluster_name, cluster_obj in var.remote_state.k8s_clusters :
    "${cluster_name}-cluster" => {
      name = "${cluster_name}-cluster"
      secrets_data = {
        name   = cluster_name
        server = "https://${var.remote_state.k8s_clusters[cluster_name].endpoint}"
        config = <<EOF
{
  "execProviderConfig": {
    "command": "argocd-k8s-auth",
    "args": ["${var.env.cloud.name}"],
    "apiVersion": "client.authentication.k8s.io/v1beta1"
  },
  "tlsClientConfig": {
    "insecure": false,
    "caData": "${var.remote_state.k8s_clusters[cluster_name].ca_certificate}"
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
    if cluster_name != var.env.short_name
  }
}
