variable "k8s_clusters" {
  description = "K8s clusters description"
  type = map(
    object(
      {
        ca_certificate = string
        endpoint       = string
      }
    )
  )
}

variable "repos" {
  description = "Repositories description"
  type = map(
    object(
      {
        deploy_keys = optional(any, {})
        org         = string
        ssh_url     = string
      }
    )
  )
}

variable "env" {
  description = "Environment description"
  type = object(
    {
      name       = string
      short_name = string
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
