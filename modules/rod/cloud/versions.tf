terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    random = {
      source = "hashicorp/random"
    }
    null = {
      source = "hashicorp/null"
    }
    deepmerge = {
      source  = "isometry/deepmerge"
      version = "1.2.1"
    }
  }
  required_version = ">= 1.8"
}
