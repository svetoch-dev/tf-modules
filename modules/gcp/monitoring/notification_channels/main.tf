resource "google_monitoring_notification_channel" "default" {
  display_name = var.name
  type         = var.type
  labels       = var.labels
}