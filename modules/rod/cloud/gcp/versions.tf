terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    deepmerge = {
      source  = "isometry/deepmerge"
      version = "1.2.1"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 1.8"
}
