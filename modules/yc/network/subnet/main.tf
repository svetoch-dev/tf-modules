resource "yandex_vpc_subnet" "this" {
  name           = var.name
  description    = var.description
  folder_id      = var.folder_id
  zone           = var.zone
  network_id     = var.network_id
  v4_cidr_blocks = [var.ip_cidr_range]
  route_table_id = var.route_table_id
}
