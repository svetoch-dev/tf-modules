locals {
  rbac_merged       = provider::deepmerge::mergo(local.rbac, var.overrides.rbac)
  namespaces_merged = provider::deepmerge::mergo(local.namespaces, var.overrides.namespaces)
}

variable "overrides" {
  description = "k8s attribute overrides"
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
