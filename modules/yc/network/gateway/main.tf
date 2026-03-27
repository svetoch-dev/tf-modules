resource "yandex_vpc_gateway" "this" {
  name        = var.name
  description = var.description
  folder_id   = var.folder_id
  labels      = var.labels

  shared_egress_gateway {}

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}
