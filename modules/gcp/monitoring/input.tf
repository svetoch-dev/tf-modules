variable "log_metrics" {
  description = "Log meterics"
  type = list(object({
    name         = string
    filter       = string
    metric_kind  = optional(string, "DELTA")
    value_type   = optional(string, "INT64")
    unit         = optional(string, "1")
    display_name = optional(string)
    labels = optional(list(object({
      key         = string
      value_type  = string
      description = string
      extractor   = string
    })), [])
    value_extractor = optional(string)
    bucket_options = optional(object({
      linear_buckets = optional(object({
        num_finite_buckets = number
        width              = number
        offset             = number
      }))
      exponential_buckets = optional(object({
        num_finite_buckets = number
        growth_factor      = number
        scale              = number
      }))
      explicit_buckets = optional(object({
        bounds = list(number)
      }))
    }), null)
  }))
  default = []
}

variable "dashboards" {
  description = "Dasboards"
  type = list(object({
    display_name = string
    columns      = optional(number, 2)
    tiles = optional(list(object({
      position = object({
        xPos   = optional(number, 0)
        yPos   = optional(number, 0)
        width  = optional(number, 24)
        height = optional(number, 16)
      })
      type        = string # Must be xyChart, logsPanel, timeTable
      title       = optional(string, "Dashboard Title")
      chart_model = optional(string, "COLOR")
      logsPanel = optional(object({ # only for logs panel
        filter        = optional(string, "")
        resourceNames = optional(list(string), [])
      }), null)
      datasets = optional(list(object({
        breakdowns  = optional(list(string), [])
        dimensions  = optional(list(string), [])
        measures    = optional(list(string), [])
        plot_type   = optional(string, "LINE")
        target_axis = optional(string, "Y1")
        promql = optional(object({
          query = string
          unit  = optional(string, "1")
        }), null)
        filter = optional(object({
          query               = string
          min_aligment_period = optional(string, "")
          resource_names      = optional(list(string), []) # only for logs panel
          aggregation = optional(object({
            alighment_period = optional(string, "60s")
            reducer          = optional(string, "REDUCE_SUM")
            aligner          = optional(string, "ALIGN_SUM")
            labels           = optional(list(string), null)
          }), null)
        }), null)
        time_series_filter = optional(object({ # only for Time series table
          direction      = optional(string, "TOP")
          num_series     = optional(number, 30)
          ranking_method = optional(string, "METHOD_MEAN")
        }), null)
      })), [])
      columns = optional(list(object({ # only for Time series table
        alignment = optional(string, "")
        column    = optional(string, "")
        visible   = optional(bool, false)
      })), [])
      metric_visual = optional(string, "BAR") # only for Time series table
      thresholds    = optional(list(string), [])
      project_id    = optional(string)
      yaxis = optional(object({
        label = optional(string, "")
        scale = optional(string, "LINEAR")
      }), {})
    })), [])
  }))
  default = []
}

variable "notification_channels" {
  type = list(object({
    displayed_name = string
    type           = string
    labels         = optional(map(string), {})
    sensitive_labels = optional(object({
      auth_token  = optional(string)
      password    = optional(string)
      service_key = optional(string)
    }), null)
  }))
  default = []
}

variable "alert_policies" {
  type = list(object({
    display_name              = string
    combiner                  = optional(string, "OR")
    severity                  = optional(string, "WARNING")
    alert_strategy_auto_close = optional(string, null)
    conditions = optional(list(object({
      display_name = string
      condition_threshold = optional(object({
        filter          = string
        threshold_value = number
        duration        = optional(string, "0s")
        comparison      = optional(string, "COMPARISON_GT")
        trigger = optional(object({
          trigger_count   = optional(number, null)
          trigger_percent = optional(number, null)
        }), null)
        aggregations = optional(object({
          alignment_period     = optional(string, null)
          per_series_aligner   = optional(string, null)
          cross_series_reducer = optional(string, null)
          group_by_fields      = optional(list(string), [])
        }), null)
      }), null)
      condition_promql = optional(object({
        query    = string
        duration = optional(string, null)
      }), null)
    })), [])
    user_labels           = optional(map(string), {})
    notification_channels = optional(list(string), [])
  }))
  default = []
}

