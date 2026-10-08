locals {
  secrets_merged = provider::deepmerge::mergo(local.secrets, var.overrides.secrets)

  connection_config = {
    for cluster_name, cluster_obj in var.argocd_clusters :
    cluster_name => lookup(
      {
        yc = jsonencode({
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
      },
      var.env.cloud.name,
      <<EOF
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
    )
  }
}

variable "overrides" {
  description = "Cloud attribute overrides"
  type = object(
    {
      secrets = optional(any)
    }
  )
  default = {
    secrets = null
  }
}
