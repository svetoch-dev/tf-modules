output "log_metric_names" {
  description = "metrics names"
  value       = module.log_metrics[*].logging_metric_name
}
