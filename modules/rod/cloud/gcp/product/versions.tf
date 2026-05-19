terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    deepmerge = {
      source = "isometry/deepmerge"
    }
  }
  required_version = ">= 1.8"
}
