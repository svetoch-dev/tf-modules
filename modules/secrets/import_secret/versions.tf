terraform {
  required_providers {
    secret = {
      source  = "inspectorioinc/secret"
      version = "1.1.5"
    }
  }
  required_version = ">= 0.13"
}
