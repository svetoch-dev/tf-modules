variable "argocd_clusters" {
  description = "Configuration for external K8s clusters to be registered in ArgoCD"
  type = map(
    object(
      {
        ca_certificate = string
        endpoint       = string
      }
    )
  )
  default = {}
}

variable "argocd_repos" {
  description = "Argocd repositories description"
  type = map(
    object(
      {
        private_key_openssh = string
        org                 = string
        ssh_url             = string
      }
    )
  )
  default = {}
}
