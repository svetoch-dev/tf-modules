terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 8.0.0, < 8.8.0"
    }
  }
  required_version = ">= 0.13"
}
