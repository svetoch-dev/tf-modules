resource "yandex_vpc_route_table" "this" {
  name        = var.name
  description = var.description
  folder_id   = var.folder_id
  network_id  = var.network_id
  labels      = var.labels

  dynamic "static_route" {
    for_each = var.static_routes

    content {
      destination_prefix = static_route.value.destination_prefix
      gateway_id         = static_route.value.gateway_id
      next_hop_address   = static_route.value.next_hop_address
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}
