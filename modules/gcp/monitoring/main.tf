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
  source       = "./dashboards"
  for_each     = { for dashboard in var.dashboards : dashboard.display_name => dashboard }
  display_name = each.value.display_name
  columns      = each.value.columns
  tiles        = each.value.tiles
}

module "notification_channels" {
  source           = "./notification_channels"
  for_each         = { for notification_channel in var.notification_channels : notification_channel.displayed_name => notification_channel }
  name             = each.value.displayed_name
  type             = each.value.type
  labels           = each.value.labels
  sensitive_labels = each.value.sensitive_labels
}

module "alert_policies" {
  source                    = "./alert_policy"
  for_each                  = { for alert_policy in var.alert_policies : alert_policy.display_name => alert_policy }
  display_name              = each.value.display_name
  alert_strategy_auto_close = each.value.alert_strategy_auto_close
  combiner                  = each.value.combiner
  conditions                = each.value.conditions
  severity                  = each.value.severity
  user_labels               = each.value.user_labels
  notification_channels     = each.value.notification_channels

  depends_on = [
    module.notification_channels
  ]
} 