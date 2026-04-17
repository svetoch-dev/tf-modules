resource "yandex_dns_recordset" "this" {
  zone_id     = var.zone_id
  name        = var.name
  type        = var.type
  ttl         = var.ttl
  data        = var.data
  description = var.description != null ? var.description : "type='${var.type}' recordset='${var.name}' with ttl='${var.ttl}'"

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}
