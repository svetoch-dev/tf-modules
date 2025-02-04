terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.51.0, < 5"
    }
  }
  required_version = ">= 0.13"
}
