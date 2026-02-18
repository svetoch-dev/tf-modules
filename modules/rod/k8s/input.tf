variable "k8s_api" {
  description = "information that is used by k8s provider to connect to k8s api"
  type = object(
    {
      endpoint = string
      token    = string
      ca_cert  = string
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
      cloud = object(
        {
          name = string
          id   = string
        }
      )
    }
  )
}

variable "overrides" {
  description = "Cloud attribute overrides"
  type = object(
    {
      rbac       = optional(any)
      namespaces = optional(any)
    }
  )
  default = {
    rbac       = null
    namespaces = null
  }
}
