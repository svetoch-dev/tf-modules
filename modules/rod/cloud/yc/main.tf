provider "yandex" {
  cloud_id  = var.env.cloud.id
  folder_id = var.env.cloud.folder_id
  zone      = var.env.cloud.location.default_zone
  region_id = var.env.cloud.location.region
}

module "yc" {
  source = "../../../yc"
  project = {
    id        = var.env.cloud.id
    folder_id = var.env.cloud.folder_id
    zone      = var.env.cloud.location.default_zone
    region    = var.env.cloud.location.region
  }
  networks = local.yc_networks_merged
  iam      = local.yc_iam_merged
  k8s      = local.yc_k8s_clusters_merged
  dns      = local.yc_dns_zones_merged
  ycrs     = local.yc_registries_merged
  s3       = local.yc_buckets_merged
}
