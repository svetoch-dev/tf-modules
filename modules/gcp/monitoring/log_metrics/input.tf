variable "name" {
  description = "Metric name"
  type        = string
}

variable "filter" {
  description = "log filters"
  type        = string
}

variable "metric_kind" {
  description = "DELTA, CUMULATIVE, GAUGE"
  type        = string
  default     = "DELTA"
}

variable "value_type" {
  description = "BOOL, INT64, DOUBLE, STRING, DISTRIBUTION, MONEY"
  type        = string
  default     = "INT64"
}

variable "unit" {
  description = "Unit type"
  type        = string
  default     = "1"
}

variable "display_name" {
  description = "Displayed metric name"
  type        = string
  default     = null
}

variable "labels" {
  description = "Metric labels"
  type = list(object({
    key         = string
    value_type  = string
    description = string
    extractor   = string
  }))
  default = []
}

variable "value_extractor" {
  description = "Ectractor values from logs"
  type        = string
  default     = null
}

variable "bucket_options" {
  description = "Bucket options"
  type = object({
    linear_buckets = optional(object({
      num_finite_buckets = number
      width              = number
      offset             = number
    }), null)
    exponential_buckets = optional(object({
      num_finite_buckets = number
      growth_factor      = number
      scale              = number
    }), null)
    explicit_buckets = optional(object({
      bounds = list(number)
    }), null)
  })
  default = null
}
