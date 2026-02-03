variable "company" {
  description = "Company related info"
  type = object(
    {
      name   = string
      domain = string
    }
  )
}

variable "ci" {
  description = "Ci related info"
  type = object(
    {
      type = string
    }
  )
}

variable "env" {
  description = "Environment description"
  type = object(
    {
      name          = string
      short_name    = string
      initial_start = optional(bool, false)
      cloud = object(
        {
          name            = string
          id              = string
          numeric_id      = optional(string)
          region          = string
          default_zone    = string
          multi_region    = string
          available_zones = list(string)
          registry        = string
          buckets = object(
            {
              deletion_protection = bool
            }
          )
        }
      )
      kubernetes = optional(
        object(
          {
            enabled             = bool
            regional            = bool
            deletion_protection = bool
            location            = string
            auth_group          = optional(string, "")
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
      gcp_apis         = optional(any)
      gcp_buckets      = optional(any)
      gcp_dns          = optional(any)
      gcp_iam          = optional(any)
      gcp_k8s_clusters = optional(any)
      gcp_logging      = optional(any)
      gcp_network      = optional(any)
      gcp_registries   = optional(any)
    }
  )
}
