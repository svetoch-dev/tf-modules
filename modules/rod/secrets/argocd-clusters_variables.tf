locals {
  argocd-clusters = {
    for cluster_name, cluster_obj in var.argocd_clusters :
    "${cluster_name}-cluster" => {
      name = "${cluster_name}-cluster"
      secrets_data = {
        name   = cluster_name
        server = "https://${cluster_obj.endpoint}"
        config = jsonencode({
          execProviderConfig = {
            command = "sh"
            args = [
              "-c",
              "/token.sh",
            ]
            env = {
              CLOUD = "${var.env.cloud.name}"
            }
            apiVersion = "client.authentication.k8s.io/v1beta1"
          }
          tlsClientConfig = {
            insecure = false
            caData   = cluster_obj.ca_certificate
          }
        })
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
