output "metric_names" {
  description = "Metrics names"
  value       = [for metric in var.log_metrics : metric.name]
}