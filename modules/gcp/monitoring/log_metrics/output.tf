output "logging_metric_name" {
  description = "name metric"
  value       = google_logging_metric.logging_metric.name
}

output "logging_metric_filter" {
  description = "metric filter"
  value       = google_logging_metric.logging_metric.filter
}
