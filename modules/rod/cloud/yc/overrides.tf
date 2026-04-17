locals {
  yc_networks_merged     = provider::deepmerge::mergo(local.yc_networks, var.overrides.yc_networks)
  yc_iam_merged          = provider::deepmerge::mergo(local.yc_iam, var.overrides.yc_iam)
  yc_buckets_merged      = provider::deepmerge::mergo(local.yc_buckets, var.overrides.yc_buckets)
  yc_dns_zones_merged    = provider::deepmerge::mergo(local.yc_dns_zones, var.overrides.yc_dns_zones)
  yc_k8s_clusters_merged = provider::deepmerge::mergo(local.yc_k8s_clusters, var.overrides.yc_k8s_clusters)
  yc_registries_merged   = provider::deepmerge::mergo(local.yc_registries, var.overrides.yc_registries)
}
