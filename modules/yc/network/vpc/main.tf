resource "yandex_vpc_network" "this" {
  name        = var.network_name
  description = var.description
  folder_id   = var.folder_id
  labels      = var.labels

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}
