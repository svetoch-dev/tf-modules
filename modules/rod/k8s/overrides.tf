locals {
  rbac = lookup(
    {
      gcp = provider::deepmerge::mergo(local.rbac_main, local.rbac_gcp)
      yc  = provider::deepmerge::mergo(local.rbac_main, local.rbac_yc)
    },
    var.env.cloud.name,
    null
  )
  rbac_merged       = provider::deepmerge::mergo(local.rbac, var.overrides.rbac)
  namespaces_merged = provider::deepmerge::mergo(local.namespaces, var.overrides.namespaces)
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
