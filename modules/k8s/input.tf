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

variable "namespaces" {
  description = "A list k8s namespaces to create"
  type        = map(any)
  default     = {}
}

variable "rbac" {
  description = "k8s rbac definition"
  type = object(
    {
      service_accounts     = any
      cluster_roles        = any
      cluster_role_binding = any
      roles                = any
      role_binding         = any
    }
  )
  default = {
    service_accounts     = {}
    cluster_roles        = {}
    cluster_role_binding = {}
    roles                = {}
    role_binding         = {}
  }
}

variable "services" {
  description = "k8s services definitions"
  type = object(
    {
      external = map(any)
    }
  )
  default = {
    external = {}
  }
}
