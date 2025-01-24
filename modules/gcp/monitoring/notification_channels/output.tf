output "notification_channel_id" {
  description = "The ID of the created notification channel."
  value       = google_monitoring_notification_channel.default.id
}

output "notification_channel_name" {
  description = "The name of the created notification channel."
  value       = google_monitoring_notification_channel.default.name
}