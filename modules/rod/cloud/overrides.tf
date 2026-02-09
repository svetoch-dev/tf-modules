locals {
  gcp_apis_merged         = provider::deepmerge::mergo(local.gcp_apis, local.overrides.gcp_apis)
  gcp_buckets_merged      = provider::deepmerge::mergo(local.gcp_buckets, local.overrides.gcp_buckets)
  gcp_dns_merged          = provider::deepmerge::mergo(local.gcp_dns, local.overrides.gcp_dns)
  gcp_iam_merged          = provider::deepmerge::mergo(local.gcp_iam, local.overrides.gcp_iam)
  gcp_k8s_clusters_merged = provider::deepmerge::mergo(local.gcp_k8s_clusters, local.overrides.gcp_k8s_clusters)
  gcp_logging_merged      = provider::deepmerge::mergo(local.gcp_logging, local.overrides.gcp_logging)
  gcp_network_merged      = provider::deepmerge::mergo(local.gcp_network, local.overrides.gcp_network)
  gcp_registries_merged   = provider::deepmerge::mergo(local.gcp_registries, local.overrides.gcp_registries)
}
