locals {
  gcp_apis_merged         = provider::deepmerge::mergo(local.gcp_apis, var.overrides.gcp_apis)
  gcp_buckets_merged      = provider::deepmerge::mergo(local.gcp_buckets, var.overrides.gcp_buckets)
  gcp_dns_merged          = provider::deepmerge::mergo(local.gcp_dns, var.overrides.gcp_dns)
  gcp_iam_merged          = provider::deepmerge::mergo(local.gcp_iam, var.overrides.gcp_iam)
  gcp_k8s_clusters_merged = provider::deepmerge::mergo(local.gcp_k8s_clusters, var.overrides.gcp_k8s_clusters)
  gcp_logging_merged      = provider::deepmerge::mergo(local.gcp_logging, var.overrides.gcp_logging)
  gcp_network_merged      = provider::deepmerge::mergo(local.gcp_network, var.overrides.gcp_network)
  gcp_registries_merged   = provider::deepmerge::mergo(local.gcp_registries, var.overrides.gcp_registries)
}
