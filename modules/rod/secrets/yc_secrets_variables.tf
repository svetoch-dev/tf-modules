locals {
  secrets_yc = {
    for cluster_name, cluster_obj in var.argocd_clusters :
    "${cluster_name}-cluster" => {
      secrets_data = {
        config = jsonencode({
          execProviderConfig = {
            command = "sh"
            args = [
              "-c",
              "yc config set instance-service-account true >/dev/null && exec yc k8s create-token --format json",
            ]
            env = {
              HOME = "/home/argocd"
            }
            apiVersion = "client.authentication.k8s.io/v1beta1"
          }
          tlsClientConfig = {
            insecure = false
            caData   = cluster_obj.ca_certificate
          }
        })
      }
    }
    if lookup(local.secrets_processed, "${cluster_name}-cluster", null) != null
  }
}
