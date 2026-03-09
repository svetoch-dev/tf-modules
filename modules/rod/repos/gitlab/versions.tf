terraform {
  required_providers {
    deepmerge = {
      source  = "isometry/deepmerge"
      version = "1.2.1"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
    }
  }
  required_version = ">= 1.8"
}
