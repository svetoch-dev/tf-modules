provider "yandex" {
  cloud_id  = var.env.cloud.id
  folder_id = var.env.cloud.folder_id
  zone      = var.env.cloud.location.default_zone
  region_id = var.env.cloud.location.region
}

module "yc" {
  source = "../../../yc"
}
