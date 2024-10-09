variable "display_name" {
  description = "Display name for the dashboard"
  type        = string
}

variable "columns" {
  description = "Number of columns in the grid layout"
  type        = number
  default     = 48
}

variable "tiles" {
  description = "tiles with widgets"
  type = list(object({
    position   = object({
      xPos   = optional(number, 0)
      yPos   = optional(number, 0)
      width  = optional(number, 24)
      height = optional(number, 16)
    })
    type          = string # Must be xyChart, logsPanel, timeTable
    title         = string
    chart_mode    = optional(string, "COLOR")
    datasets      = optional(list(object({
      breakdowns    = optional(list(string), [])
      dimensions    = optional(list(string), [])
      measures      = optional(list(string), [])
      plot_type     = optional(string, "LINE")
      target_axis   = optional(string, "Y1")
      metric_visual = optional(string, null) # Only for Time series table
      promql        = optional(object({
        query = string
        unit  = optional(string, "1")
      }), null)
      filter      = optional(object({
        query = string
        resource_names = optional(list(string), []) # only for logs panel
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
    thresholds    = optional(list(string), [])
    project_id    = optional(string)
    yaxis         = optional(object({
      label = optional(string, "")
      scale = optional(string, "LINEAR")
    }), {})
  }))
}
