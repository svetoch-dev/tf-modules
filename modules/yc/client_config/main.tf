provider "yandex" {
  cloud_id  = var.provider_config.id
  folder_id = var.provider_config.folder_id
  zone      = var.provider_config.default_zone
  region    = var.provider_config.region
}

data "yandex_client_config" "client" {}
