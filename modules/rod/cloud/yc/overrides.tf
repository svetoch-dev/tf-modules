locals {
  yc_networks_merged     = provider::deepmerge::mergo(local.yc_networks, var.overrides.yc_networks)
  yc_iam_merged          = provider::deepmerge::mergo(local.yc_iam, var.overrides.yc_iam)
  yc_buckets_merged      = provider::deepmerge::mergo(local.yc_buckets, var.overrides.yc_buckets)
  yc_dns_zones_merged    = provider::deepmerge::mergo(local.yc_dns_zones, var.overrides.yc_dns_zones)
  yc_k8s_clusters_merged = provider::deepmerge::mergo(local.yc_k8s_clusters, var.overrides.yc_k8s_clusters)
  yc_registries_merged   = provider::deepmerge::mergo(local.yc_registries, var.overrides.yc_registries)
}

variable "overrides" {
  description = "Cloud attribute overrides"
  type = object(
    {
      yc_buckets      = optional(any)
      yc_dns_zones    = optional(any)
      yc_iam          = optional(any)
      yc_k8s_clusters = optional(any)
      yc_networks     = optional(any)
      yc_registries   = optional(any)
    }
  )
  default = {
    yc_buckets      = null
    yc_dns_zones    = null
    yc_iam          = null
    yc_k8s_clusters = null
    yc_networks     = null
    yc_registries   = null
  }
}
