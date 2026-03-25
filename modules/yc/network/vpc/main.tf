resource "yandex_vpc_network" "this" {
  name        = var.network_name
  description = var.description
  folder_id   = var.folder_id
}
