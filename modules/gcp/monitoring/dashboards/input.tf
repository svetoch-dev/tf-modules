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
    filter        = optional(string)  # Metric filter or PromQL query
    plot_type     = optional(string, "LINE")  # Default plot type
    y_axis_label  = optional(string, "y1Axis")
    scale         = optional(string, "LINEAR")
    promql        = optional(string)  # For PromQL queries
    columns       = optional(list(map(string))) # For timeSeriesTable
  }))
}
