resource "google_datastore_index" "this" {
  kind = var.kind

  dynamic "properties" {
    for_each = var.properties
    content {
      name      = properties.value.name
      direction = properties.value.direction
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}
