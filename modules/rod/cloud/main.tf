module "gcp" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp?ref=gcp-v2.7.0"
  #Use for_each so that resources path prefix
  #would be module.gcp["this"]
  for_each = var.env.cloud.name == "gcp" ? {
    "this" = ""
  } : {}
  project = {
    id     = var.env.cloud.id
    region = var.env.cloud.region
  }

  activate_apis = local.gcp_activate_apis
  networks      = local.gcp_networks
  gke_clusters  = local.gcp_k8s_clusters
  logging       = local.gcp_logging
  gars          = local.gcp_registries
  iam           = local.gcp_iam
  dns_zones     = local.gcp_dns_zones
  gcs           = local.gcp_buckets
}
