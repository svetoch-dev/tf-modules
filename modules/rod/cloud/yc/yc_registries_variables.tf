locals {
  yc_registries = {
    containers = {
      writers = var.env.short_name != "int" && var.env.initial_start != true ? [
        "serviceAccount:${module.yc.iam.service_accounts["runner-app"].id}"
      ] : []
    }
  }
}
