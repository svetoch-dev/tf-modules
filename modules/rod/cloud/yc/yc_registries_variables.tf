locals {
  yc_registries = {
    containers = {
      writers = var.env.short_name != "int" && var.env.initial_start == true ? [
        "serviceAccount:${data.yandex_iam_service_account.sa_int["runner-app"].id}"
      ] : []
    }
  }
}
