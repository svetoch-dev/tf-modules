terraform {
  required_providers {
    secret = {
      source  = "inspectorioinc/secret"
      version = "1.1.4"
    }
  }
}

resource "secret_resource" "secret" {
}
