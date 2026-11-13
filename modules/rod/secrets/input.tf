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

variable "app_runner_private_key" {
  description = "OpenSSH private key for the application runner infrastructure deploy key; null disables its Kubernetes Secret"
  type        = string
  default     = null
}
