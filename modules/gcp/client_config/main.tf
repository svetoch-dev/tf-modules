provider "google" {
  project = var.provider.id
  region  = var.provider.region
  zone    = var.provider.default_zone
}

data "google_client_config" "client" {}
