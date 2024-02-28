terraform {
  required_providers {
    secret = {
      source = "inspectorioinc/secret"
    }
  }
}

resource "secret_resource" "secret" {
}
