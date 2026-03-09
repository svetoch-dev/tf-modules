terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
    deepmerge = {
      source  = "isometry/deepmerge"
      version = "1.2.1"
    }
  }
  required_version = ">= 1.8"
}
