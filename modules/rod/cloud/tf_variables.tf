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
  default = null
}

variable "apps" {
  description = "Application related info"
  type = map(
    object(
      {
        name = string
      }
    )
  )
  default = {}
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
          name = string
          id   = string
          location = object(
            {
              region       = string
              default_zone = string
              multi_region = string
            }
          )
          network = object(
            {
              vm_cidr          = string
              k8s_pod_cidr     = string
              k8s_service_cidr = string
            }
          )
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
            deletion_protection = optional(bool, true)
            node_locations      = list(string)
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
      gcp_activate_apis     = optional(any)
      gcp_buckets           = optional(any)
      gcp_dns_zones         = optional(any)
      gcp_iam               = optional(any)
      gcp_k8s_clusters      = optional(any)
      gcp_logging           = optional(any)
      gcp_networks          = optional(any)
      gcp_registries        = optional(any)
      gcp_k8s_cluster_nodes = optional(any)
    }
  )
  default = {
    gcp_activate_apis     = null
    gcp_buckets           = null
    gcp_dns_zones         = null
    gcp_iam               = null
    gcp_k8s_clusters      = null
    gcp_k8s_cluster_nodes = null
    gcp_logging           = null
    gcp_networks          = null
    gcp_registries        = null
  }
}
