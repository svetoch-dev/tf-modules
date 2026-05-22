locals {
  rbac_processed       = provider::deepmerge::mergo(local.rbac, var.overrides.rbac)
  namespaces_processed = provider::deepmerge::mergo(local.namespaces, var.overrides.namespaces)

  rbac_merged = lookup(
    {
      gcp = provider::deepmerge::mergo(local.rbac_processed, local.rbac_gcp)
      yc  = provider::deepmerge::mergo(local.rbac_processed, local.rbac_yc)
    },
    var.env.cloud.name,
    null
  )

  namespaces_merged = local.namespaces_processed
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
