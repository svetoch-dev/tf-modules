locals {
  argocd-clusters = {
    for cluster_name, cluster_obj in var.argocd_clusters :
    "${cluster_name}-cluster" => {
      name = "${cluster_name}-cluster"
      secrets_data = {
        name   = cluster_name
        server = "https://${cluster_obj.endpoint}"
        config = local.connection_config[cluster_name]
      }
      k8s = {
        enabled   = true
        namespace = "argocd"
      }
      annotations = {}
      labels = {
        "argocd.argoproj.io/secret-type" = "cluster"
      }
    }
  }
}
