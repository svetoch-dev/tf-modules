variable "metric_name" {
  description = "The name of the logging metric."
  type        = string
}

variable "filter" {
  description = "The filter for the logging metric."
  type        = string
}

variable "metric_descriptor" {
  description = "Metricc descriptor"
  type = object({
    metric_kind  = string
    value_type   = string
    unit         = string
    display_name = string
    labels = map(object({
      key             = string
      value_type      = string
      description     = string
      label_extractor = string
    }))
  })
  default = {
    metric_kind  = "DELTA"  
    value_type   = "INT64"  
    unit         = "1"        
  }
} 

variable "value_extractor" {
  description = "Extractor for the value."
  type        = string
  default     = ""
}

variable "bucket_type" {
  description = "The type of the bucket (linear, exponential, or explicit)."
  type        = string
  default     = null
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