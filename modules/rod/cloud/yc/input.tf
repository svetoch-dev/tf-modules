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

variable "int_env" {
  description = "Definition of internal environment"
  #should have the same schema as var.env below
  type = any
}

variable "env" {
  description = "Environment description"
  type = object(
    {
      name          = string
      short_name    = string
      initial_start = optional(bool, false)
      users = map(
        object(
          {
            name  = string
            roles = list(string)
          }
        )
      )
      apps = map(
        object(
          {
            name     = string
            postgres = optional(bool, false)
            redis    = optional(bool, false)
            rabbitmq = optional(bool, false)
            access_roles = optional(
              object(
                {
                  port_forward = optional(string, "dev")
                }
              ),
              {
                port_forward = "dev"
              }
            )
          }
        )
      )
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
              multi_regional      = bool
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
      yc_buckets      = optional(any)
      yc_dns_zones    = optional(any)
      yc_iam          = optional(any)
      yc_k8s_clusters = optional(any)
      yc_networks     = optional(any)
      yc_registries   = optional(any)
    }
  )
  default = {
    yc_buckets      = null
    yc_dns_zones    = null
    yc_iam          = null
    yc_k8s_clusters = null
    yc_networks     = null
    yc_registries   = null
  }
}
