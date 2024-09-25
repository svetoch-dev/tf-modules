variable "metric_name" {
  description = "The name of the logging metric."
  type        = string
}

variable "display_name" {
  description = "Metric displayed name"
  type        = string
}

variable "filter" {
  description = "The filter for the logging metric."
  type        = string
}

variable "metric_kind" {
  description = "The kind of the metric (DELTA or GAUGE)."
  type        = string
  default     = "DELTA"
}

variable "value_type" {
  description = "The value type of the metric."
  type        = string
  default     = "INT64"
}

variable "unit" {
  description = "The unit of the metric."
  type        = string
  default     = "1"
}

variable "labels" {
  description = "labels"
  type = list(object({
    key         = string
    value_type  = string
    description = string
  }))
}

variable "label_extractors" {
  description = "Extractors for labels."
  type        = map(string)
  default     = {}
}

variable "value_extractor" {
  description = "Extractor for the value."
  type        = string
  default     = ""
}

variable "bucket_type" {
  description = "The type of the bucket (linear, exponential, or explicit)."
  type        = string
  default     = "linear"
}

variable "linear_buckets" {
  description = "Configuration for linear buckets."
  type        = object({
    num_finite_buckets = number
    width              = number
    offset             = number
  })
  default = null
}

variable "exponential_buckets" {
  description = "Configuration for exponential buckets."
  type        = object({
    num_finite_buckets = number
    growth_factor      = number
    scale              = number
  })
  default = null
}

variable "explicit_buckets" {
  description = "Configuration for explicit buckets."
  type        = list(number)
  default     = null
}

variable "disabled" {
    description = "Type 'true' if you want to disable metric"
    type        = bool
    default     = false
}