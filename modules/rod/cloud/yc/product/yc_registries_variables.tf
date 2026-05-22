locals {
  yc_registries = {
    containers = {
      writer_names = [
        "serviceAccountName:${var.int_env.cloud.folder_id}:runner-app-${var.int_env.short_name}"
      ]
    }
  }
}
