data "google_monitoring_notification_channel" "channels" {
  for_each = toset([
    for name in var.notification_channels : name
    if !startswith(name, "projects/")
  ])

  display_name = each.key
}

resource "google_monitoring_alert_policy" "default" {
  display_name = var.display_name
  combiner     = var.combiner

  dynamic "alert_strategy" {
    for_each = var.alert_strategy_auto_close != null ? [var.alert_strategy_auto_close] : []
    content {
      auto_close = alert_strategy.value.auto_close
    }
  }

  dynamic "conditions" {
    for_each = var.conditions
    content {
      display_name = conditions.value.display_name

      dynamic "condition_threshold" {
        for_each = conditions.value.condition_threshold != null ? [conditions.value.condition_threshold] : []
        content {
          filter          = condition_threshold.value.filter
          duration        = condition_threshold.value.duration
          comparison      = condition_threshold.value.comparison
          threshold_value = condition_threshold.value.threshold_value

          dynamic "trigger" {
            for_each = condition_threshold.value.trigger != null ? [condition_threshold.value.trigger] : []
            content {
              count   = trigger.value.trigger_count
              percent = trigger.value.trigger_percent
            }
          }

          dynamic "aggregations" {
            for_each = condition_threshold.value.aggregations != null ? [condition_threshold.value.aggregationsr] : []
            content {
              alignment_period     = aggregations.value.alignment_period
              per_series_aligner   = aggregations.value.per_series_aligner
              cross_series_reducer = aggregations.value.cross_series_reducer
              group_by_fields      = aggregations.value.group_by_fields
            }
          }
        }
      }

      dynamic "condition_prometheus_query_language" {
        for_each = conditions.value.condition_promql != null ? [conditions.value.condition_promql] : []
        content {
          query    = condition_prometheus_query_language.value.query
          duration = condition_prometheus_query_language.value.duration
        }
      }
    }
  }
  notification_channels = [for name in var.notification_channels : (
    startswith(name, "projects/") ? name : try(
      data.google_monitoring_notification_channel.channels[name].id,
      name
    )
  )]
  severity    = var.severity
  user_labels = var.user_labels

}

