locals {
  gcp_activate_apis_merged = var.overrides.gcp_activate_apis == null ? local.gcp_activate_apis : var.overrides.gcp_activate_apis
  gcp_buckets_merged       = provider::deepmerge::mergo(local.gcp_buckets, var.overrides.gcp_buckets)
  gcp_dns_zones_merged     = provider::deepmerge::mergo(local.gcp_dns_zones, var.overrides.gcp_dns_zones)
  gcp_iam_merged           = provider::deepmerge::mergo(local.gcp_iam, var.overrides.gcp_iam)
  gcp_k8s_clusters_merged  = provider::deepmerge::mergo(local.gcp_k8s_clusters, var.overrides.gcp_k8s_clusters)
  gcp_logging_merged       = provider::deepmerge::mergo(local.gcp_logging, var.overrides.gcp_logging)
  gcp_networks_merged      = provider::deepmerge::mergo(local.gcp_networks, var.overrides.gcp_networks)
  gcp_registries_merged    = provider::deepmerge::mergo(local.gcp_registries, var.overrides.gcp_registries)
}
