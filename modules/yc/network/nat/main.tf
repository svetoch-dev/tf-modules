resource "yandex_vpc_gateway" "this" {
  name      = var.name
  folder_id = var.folder_id

  shared_egress_gateway {}
}
