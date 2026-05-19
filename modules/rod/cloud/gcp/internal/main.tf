module "internal" {
  source  = "../"
  company = var.company
  ci      = var.ci
  int_env = var.int_env
  env     = var.env
  overrides = {
    gcp_activate_apis = local.gcp_activate_apis_merged
    gcp_buckets       = local.gcp_buckets_merged
    gcp_dns_zones     = local.gcp_dns_zones_merged
    gcp_iam           = local.gcp_iam_merged
    gcp_k8s_clusters  = local.gcp_k8s_clusters_merged
    gcp_logging       = local.gcp_logging_merged
    gcp_networks      = local.gcp_networks_merged
    gcp_registries    = local.gcp_registries_merged
  }
}
