resource "google_firestore_index" "this" {
  collection = var.collection

  dynamic "fields" {
    for_each = var.fields
    content {
      field_path = fields.value.field_path
      order      = fields.value.order
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}