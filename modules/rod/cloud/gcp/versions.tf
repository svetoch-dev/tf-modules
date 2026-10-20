terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.7.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "8.7.0"
    }
    deepmerge = {
      source  = "isometry/deepmerge"
      version = "1.2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.9.1"
    }
  }
  required_version = ">= 1.8"
}
