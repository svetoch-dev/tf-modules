locals {
  yc_networks_merged = provider::deepmerge::mergo(local.yc_networks, var.overrides.yc_networks)
  yc_iam_merged      = provider::deepmerge::mergo(local.yc_iam, var.overrides.yc_iam)
}
