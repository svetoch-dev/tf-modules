resource "yandex_dns_zone" "this" {
  folder_id           = var.folder_id
  name                = var.name
  zone                = var.zone
  description         = var.description
  labels              = var.labels
  public              = var.public
  private_networks    = var.private_networks
  deletion_protection = var.deletion_protection

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}

resource "yandex_dns_zone_iam_binding" "this" {
  for_each = {
    for iam_role in var.iam_roles :
    iam_role.role => iam_role
  }

  dns_zone_id = yandex_dns_zone.this.id
  role        = each.value.role
  members     = each.value.members
}
