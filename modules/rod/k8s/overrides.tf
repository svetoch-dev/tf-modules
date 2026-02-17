locals {
  rbac = lookup(
    {
      gcp = provider::deepmerge::mergo(local.rbac_main, local.rbac_gcp)
    },
    var.env.name,
    null
  )
  rbac_merged       = provider::deepmerge::mergo(local.rbac, var.overrides.rbac)
  namespaces_merged = provider::deepmerge::mergo(local.namespaces, var.overrides.namespaces)
}
