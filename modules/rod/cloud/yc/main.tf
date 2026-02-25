provider "yandex" {
  cloud_id  = var.env.cloud.id
  folder_id = var.env.cloud.folder_id
  zone      = var.env.cloud.default_zone
  region    = var.env.cloud.region
}

module "yc" {
  source = "../../../yc"
}
