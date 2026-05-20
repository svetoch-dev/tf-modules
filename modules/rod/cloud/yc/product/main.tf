provider "yandex" {
  cloud_id  = var.env.cloud.id
  folder_id = var.env.cloud.folder_id
  zone      = var.env.cloud.location.default_zone
  region_id = var.env.cloud.location.region
}

module "product" {
  source  = "../"
  company = var.company
  ci      = var.ci
  int_env = var.int_env
  env     = var.env
  overrides = {
    yc_buckets      = local.yc_buckets_merged
    yc_dns_zones    = local.yc_dns_zones_merged
    yc_iam          = local.yc_iam_merged
    yc_k8s_clusters = local.yc_k8s_clusters_merged
    yc_networks     = local.yc_networks_merged
    yc_registries   = local.yc_registries_merged
  }

}
