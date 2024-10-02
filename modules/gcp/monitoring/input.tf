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
    widgets      = optional(list(object{
      type          = string
      title         = string
      filter        = optional(string)  # Metric filter or PromQL query
      plot_type     = optional(string, "LINE")  # Default plot type
      y_axis_label  = optional(string, "y1Axis")
      scale         = optional(string, "LINEAR")
      promql        = optional(string)  # For PromQL queries
      columns       = optional(list(map(string))) # For timeSeriesTable
    }))
  }))
}
