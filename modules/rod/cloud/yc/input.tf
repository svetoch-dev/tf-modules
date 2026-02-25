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
      apps = map(
        object(
          {
            name     = string
            postgres = optional(bool, false)
            redis    = optional(bool, false)
            rabbitmq = optional(bool, false)
            devs     = optional(list(string), [])
          }
        )
      )
      cloud = object(
        {
          name      = string
          id        = string
          folder_id = string
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
