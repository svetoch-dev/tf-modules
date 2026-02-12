terraform {
  required_providers {
    github = {
      source  = "integrations/github"
    }
    tls = {
      source  = "hashicorp/tls"
    }
    deepmerge = {
      source  = "isometry/deepmerge"
      version = "1.2.1"
    }
  }
  required_version = ">= 1.8"
}
