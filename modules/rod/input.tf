variable "company" {
  description = "Company related info"
  type = object(
    {
      name   = string
      domain = string
    }
  )
  default = null
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

variable "int_env" {
  description = "Definition of internal environment"
  #should have the same schema as var.env below
  type    = any
  default = null
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
      registry = object(
        {
          type = string
          url  = string
        }
      )
      dns = object(
        {
          domain = string
          type   = string
        }
      )
      cloud = object(
        {
          name      = string
          id        = string
          folder_id = optional(string)
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
  default = null
}
