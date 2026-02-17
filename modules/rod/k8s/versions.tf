terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    yandex = {
      source = "yandex-cloud/yandex"
    }
    deepmerge = {
      source  = "isometry/deepmerge"
      version = "1.2.1"
    }
  }
  required_version = ">= 1.8"
}
