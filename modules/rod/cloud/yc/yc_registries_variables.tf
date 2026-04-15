locals {
  yc_registries = {
    containers = {
      readers = var.env.initial_start ? [] : [
        "serviceAccount:${module.yc.iam.service_accounts["k8s-nodes"].id}"
      ]
      writers = var.env.short_name != "int" && var.env.initial_start != true ? [
        "serviceAccount:${module.yc.iam.service_accounts["runner-app"].id}"
      ] : []
    }
  }
}
