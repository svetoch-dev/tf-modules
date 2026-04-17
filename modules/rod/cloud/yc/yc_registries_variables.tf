locals {
  yc_registries = {
    containers = {
      writer_names = var.env.short_name != "int" ? [
        "serviceAccountName:${var.int_env.cloud.folder_id}:runner-${var.int_env.short_name}"
      ] : []
    }
  }
}
