variable "display_name" {
  description = "Display name for the dashboard"
  type        = string
}

variable "columns" {
  description = "Number of columns in the grid layout"
  type        = number
  default     = 2
}

variable "widgets" {
  description = "List of widgets to display on the dashboard"
  type = list(object({
    type          = string            # "xyChart", "timeSeriesTable", "logsPanel", etc.
    title         = string            # Title of the widget
    y_axis_label  = optional(string, "y1Axis")
    scale         = optional(string, "LINEAR")
    columns       = optional(list(map(string)))  # For timeSeriesTable
    data          = optional(list(object({
      promql        = optional(string, null)
      filter        = optional(string, null)
      plot_type     = optional(string, "LINE")
      agregation    = optional(object({
        period = optional(string, "60s")
        reducer = optional(string, "REDUCE_SUM")
        aligner = optional(string, "ALIGN_SUM")
        group_fields = optional(list(string), [])
      }, null))
    })))
  }))
}
