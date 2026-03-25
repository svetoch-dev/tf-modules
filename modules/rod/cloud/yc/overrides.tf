locals {
  yc_networks_merged = provider::deepmerge::mergo(local.yc_networks, var.overrides.yc_networks)
}
