module "log_metrics" {
  source = "./log_metrics"

  for_each = { for metric in var.log_metrics : metric.name => metric }

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
  for_each = { for dashboard in var.dashboards : dashboard.display_name => dashboard }
  display_name = each.value.display_name
  columns = each.value.columns
  tiles = each.value.tiles
}

module "notification_channels" {
  source   = "./notification_channels"
  for_each = { for notification_channel in var.notification_channels : notification_channel.display_name => otification_channel }
  name     = each.value.display_name
  type     = each.value.type
  labels   = each.value.labels
}