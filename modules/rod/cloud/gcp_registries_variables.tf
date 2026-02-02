locals {
  gcp_registries = {
    containers = {
      location = var.env.cloud.region
      readers = [
        "serviceAccount:k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
      ]
      writers = [
      ]
      description = "container images"
    }
  }
}
