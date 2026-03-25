resource "yandex_vpc_route_table" "this" {
  name       = var.name
  folder_id  = var.folder_id
  network_id = var.network_id

  dynamic "static_route" {
    for_each = var.static_routes

    content {
      destination_prefix = static_route.value.destination_prefix
      gateway_id         = static_route.value.gateway_id
      next_hop_address   = static_route.value.next_hop_address
    }
  }
}
