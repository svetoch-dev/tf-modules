terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 8.0.0, < 8.8.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 8.0.0, < 8.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0, < 3.10.0"
    }
  }
  required_version = ">= 0.13"
}
