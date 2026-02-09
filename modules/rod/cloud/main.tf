module "gcp" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp?ref=gcp-v2.7.0"
  #Use for_each so that resources path prefix
  #would be module.gcp["this"]
  for_each = var.env.cloud.name == "gcp" ? {
    "this" = ""
  } : {}
  project = {
    id     = var.env.cloud.id
    region = var.env.cloud.location.region
  }

  activate_apis = local.gcp_activate_apis_merged
  gcs           = local.gcp_buckets_merged
  dns_zones     = local.gcp_dns_zones_merged
  iam           = local.gcp_iam_merged
  gke_clusters  = local.gcp_k8s_clusters_merged
  logging       = local.gcp_logging_merged
  networks      = local.gcp_networks_merged
  gars          = local.gcp_registries_merged
}
