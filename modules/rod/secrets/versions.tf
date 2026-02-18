terraform {
  required_providers {
    deepmerge = {
      source  = "isometry/deepmerge"
      version = "1.2.1"
    }
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    secret = {
      source = "inspectorioinc/secret"
    }
  }
  required_version = ">= 1.8"
}
