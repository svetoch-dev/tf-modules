terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.40.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "6.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
  required_version = ">= 0.13"
}
