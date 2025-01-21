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

          trigger {
            count   = condition_threshold.value.trigger_count
            percent = condition_threshold.value.trigger_percent
          }

          aggregations {
            alignment_period     = condition_threshold.value.alignment_period
            per_series_aligner   = condition_threshold.value.per_series_aligner
            cross_series_reducer = condition_threshold.value.cross_series_reducer
            group_by_fields      = condition_threshold.value.group_by_fields
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

