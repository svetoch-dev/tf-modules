provider "yandex" {
  cloud_id  = var.provider.id
  folder_id = var.provider.folder_id
  zone      = var.provider.default_zone
  region    = var.provider.region
}

data "yandex_client_config" "client" {}
