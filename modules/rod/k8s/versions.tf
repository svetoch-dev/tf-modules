terraform {
  required_providers {
    deepmerge = {
      source = "isometry/deepmerge"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 1.8"
}
