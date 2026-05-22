variable "namespaces" {
  description = "A list k8s namespaces to create"
  type        = map(any)
  default     = {}
}

variable "rbac" {
  description = "k8s rbac definition"
  type = object(
    {
      service_accounts     = optional(any, {})
      cluster_roles        = optional(any, {})
      cluster_role_binding = optional(any, {})
      roles                = optional(any, {})
      role_binding         = optional(any, {})
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
