provider "google" {
  project = var.provider_config.id
  region  = var.provider_config.region
  zone    = var.provider_config.default_zone
}

data "google_client_config" "client" {}
