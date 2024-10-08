module "log_metrics" {
  source = "./log_metrics"

  for_each = { for metric in var.monitoring.log_metrics : metric.name => metric }

  name            = each.value.name
  filter          = each.value.filter
  metric_kind     = each.value.metric_kind
  value_type      = each.value.value_type
  unit            = each.value.unit
  display_name    = each.value.display_name
  labels          = each.value.labels
  value_extractor = each.value.value_extractor
  bucket_options  = each.value.bucket_options
}

module "dashboards" {
  source = "./dashboards"
  for_each = var.monitoring.dashboards
  display_name = each.value.display_name
  columns = each.value.columns
  widgets = each.value.widgets
}