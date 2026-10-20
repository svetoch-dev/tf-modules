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
    random = {
      source  = "hashicorp/random"
      version = "3.9.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.3.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    secret = {
      source = "inspectorioinc/secret"
    }
  }
  required_version = ">= 0.13"
}
