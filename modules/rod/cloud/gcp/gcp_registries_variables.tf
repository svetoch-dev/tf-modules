locals {
  gcp_registries = {
    containers = {
      location = var.env.cloud.location.region
      readers = [
        "serviceAccount:k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
      ]
      writers = [
        "serviceAccount:runner-app@${var.int_env.cloud.id}.iam.gserviceaccount.com"
      ]
      description = "container images"
    }
  }
}
