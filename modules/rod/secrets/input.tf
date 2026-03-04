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

variable "env" {
  description = "Environment description"
  type = object(
    {
      short_name    = string
      initial_start = optional(bool, false)
      cloud = object(
        {
          name = string
        }
      )
      import_secrets = map(
        object(
          {
            name              = string
            k8s_enabled       = optional(bool, true)
            namespace         = optional(string)
            base64_secrets    = optional(bool, false)
            secrets_to_import = list(string)
          }
        )
      )
      default = {}
    }
  )
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
