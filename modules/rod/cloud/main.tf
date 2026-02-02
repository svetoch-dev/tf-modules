module "gcp" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp?ref=gcp-v2.7.0"
  project = {
    id     = var.env.cloud.id
    region = var.env.cloud.region
  }

  activate_apis = local.gcp_activate_apis
  networks      = local.networks
  gke_clusters  = local.gke_clusters
  logging       = local.logging
  gars          = local.gcp_registries
  iam           = local.gcp_iam
  dns_zones     = local.gcp_dns_zones
  gcs           = local.gcp_buckets
}
