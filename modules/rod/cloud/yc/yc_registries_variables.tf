locals {
  yc_registries = {
    containers = {
      readers = [
        "serviceAccount:${module.yc.iam.service_accounts["k8s-nodes"].id}"
      ]
      writers = var.env.short_name != "int" ? [
        "serviceAccount:${module.yc.iam.service_accounts["runner-app"].id}"
      ] : []
    }
  }
}
