variable "log_metrics" {
  description = "Log meterics"
  type = list(object({
    name           = string
    filter         = string
    metric_kind    = optional(string, "DELTA")
    value_type     = optional(string, "INT64")
    unit           = optional(string, "1")
    display_name   = optional(string)
    labels         = optional(list(object({
      key         = string
      value_type  = string
      description = string
      extractor   = string
    })), [])
    value_extractor  = optional(string)
    bucket_options   = optional(object({
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
    tiles        = optional(list(object({
      position   = object({
        xpos   = optional(number, 0)
        ypos   = optional(number, 0)
        width  = optional(number, 24)
        height = optional(number, 16)
      })
      type          = string # Must be xyChart, logsPanel, timeTable
      title         = string
      chart_model   = optional(string, "COLOR")
      datasets      = optional(list(object({
        breakdowns    = optional(list, [])
        dimensions    = optional(list, [])
        measures      = optional(list, [])
        plot_type     = optional(string, "LINE")
        target_axis   = optional(string, "Y1")
        metric_visual = optional(string, null) # Only for Time series table
        promql        = optional(object({
          query = string
          unit  = optional(string, "1")
        }), null)
        filter      = optional(object({
          query = string
          aggregation = optional(object({
            alighment_period = optional(string, "60s")
            reducer          = optional(string, "REDUCE_SUM")
            aligner          = optional(string, "ALIGN_SUM")
            labels           = optional(list(string), [])
          }),null)
        }), null)
        time_series_filter = optional(object({
          direction    = optional(string, "TOP")
          num_series     = optional(number, 30)
          ranking_method = optional(string, "METHOD_MEAN")
        }), null)
      })), [])
      columns     = optional(list(object({
        alignment = optional(string, "")
        column    = optional(string, "")
        visible   = optional(bool, false)
      })), [])
      treshholds    = optional(list(string), [])
      project_id    = optional(string)
      yaxis         = optional(object({
        label = optional(string, "")
        scale = optional(string, "LINEAR")
      }), {})
    })), [])
  }))
}
