resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = var.display_name
  combiner     = var.combiner

  dynamic "alert_strategy" {
    for_each = var.alert_strategies
    content {
      auto_close           = alert_strategy.value.auto_close
      notification_prompts = alert_strategy.value.notification_prompts
    }
  }

  dynamic "conditions" {
    for_each = var.conditions
    content {
      display_name = conditions.value.display_name

      condition_threshold {
        filter          = conditions.value.filter
        duration        = conditions.value.duration
        comparison      = conditions.value.comparison
        threshold_value = conditions.value.threshold_value

        trigger {
          count = conditions.value.trigger_count
        }

        aggregations {
          alignment_period     = conditions.value.aggregation.alignment_period
          per_series_aligner   = conditions.value.aggregation.per_series_aligner
          cross_series_reducer = conditions.value.aggregation.cross_series_reducer
          group_by_fields      = conditions.value.aggregation.group_by_fields
        }
      }
    }
  }
  notification_channels = var.notification_channels
  severity              = var.severity
  user_labels           = var.user_labels
}