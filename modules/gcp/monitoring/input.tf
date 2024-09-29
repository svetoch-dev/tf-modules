variable "log_metrics" {
  description = "List with log metrics"
  type = map(object({
    name                = string
    filter              = string
    metric_descriptor   = object({
      metric_kind  = optional(string, "DELTA")
      value_type   = optional(string, "INT64")
      unit         = optional(string, "1")
      display_name = string
      labels = optional(map(object({
        key             = string
        value_type      = string
        description     = string
        label_extractor = string
      })))
    })
    value_extractor     = string
    disabled            = optional(bool, false)
    bucket_type         = optional(string)
    linear_buckets      = optional(object({
      num_finite_buckets = number
      width              = number
      offset             = number
    }))
    exponential_buckets = optional(object({
      num_finite_buckets = number
      growth_factor      = number
      scale              = number
    }))
    explicit_buckets    = optional(list(number))
  }))
}
