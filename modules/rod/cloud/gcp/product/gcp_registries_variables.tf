locals {
  gcp_registries = {
    containers = {
      writers = [
        "serviceAccount:runner-app@${var.int_env.cloud.id}.iam.gserviceaccount.com"
      ]
    }
  }
}
