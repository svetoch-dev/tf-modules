provider "google" {
  project = var.env.cloud.id
  region  = var.env.cloud.location.region
  zone    = var.env.cloud.location.default_zone
}

provider "google-beta" {
  project = var.env.cloud.id
  region  = var.env.cloud.location.region
  zone    = var.env.cloud.location.default_zone
}

data "google_project" "project" {}

module "gcp" {
  source = "../../../gcp"
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
