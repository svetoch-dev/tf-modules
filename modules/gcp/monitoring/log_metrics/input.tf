variable "name" {
  description = "Имя метрики"
  type        = string
}

variable "filter" {
  description = "Фильтр логов"
  type        = string
}

variable "metric_kind" {
  description = "Тип метрики (DELTA, CUMULATIVE, GAUGE)"
  type        = string
  default     = "DELTA"
}

variable "value_type" {
  description = "Тип значений метрики (INT64, DOUBLE, DISTRIBUTION)"
  type        = string
  default     = "INT64"
}

variable "unit" {
  description = "Единица измерения для метрики"
  type        = string
  default     = "1"
}

variable "display_name" {
  description = "Отображаемое имя метрики"
  type        = string
  default     = null
}

variable "labels" {
  description = "Массив меток для метрики"
  type = list(object({
    key         = string
    value_type  = string
    description = string
    extractor   = string
  }))
  default = []
}

variable "value_extractor" {
  description = "Экстрактор значения из логов"
  type        = string
  default     = null
}

variable "bucket_options" {
  description = "Настройки для бакетов, если используется Distribution"
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
