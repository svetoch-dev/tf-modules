resource "yandex_vpc_subnet" "this" {
  name           = var.name
  description    = var.description
  folder_id      = var.folder_id
  labels         = var.labels
  zone           = var.zone
  network_id     = var.network_id
  v4_cidr_blocks = var.ip_cidr_ranges
  route_table_id = var.route_table_id

  dynamic "dhcp_options" {
    for_each = var.dhcp_options == null ? [] : [var.dhcp_options]

    content {
      domain_name         = try(dhcp_options.value.domain_name, null)
      domain_name_servers = try(dhcp_options.value.domain_name_servers, null)
      ntp_servers         = try(dhcp_options.value.ntp_servers, null)
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
