variable "display_name" {
  description = "The display name of the alert policy."
  type        = string
}

variable "combiner" {
  description = "The combiner for the alert policy (AND, OR or AND_WITH_MATCHING_RESOURCE)."
  type        = string
  default     = "OR"
}

variable "alert_strategy_auto_close" {
  description = "A list of alert strategies for the alert policy."
  type        = string
  default     = null
}

variable "conditions" {
  description = "value"
  type = list(object({
    display_name = string
    condition_threshold = optional(object({
      filter          = string
      threshold_value = number
      duration        = optional(string, "0s")
      comparison      = optional(string, "COMPARISON_GT")
      trigger = optional(object({
        trigger_count   = optional(number, null)
        trigger_percent = optional(number, null)
      }), null)
      aggregations = optional(object({
        alignment_period     = optional(string, null)
        per_series_aligner   = optional(string, null)
        cross_series_reducer = optional(string, null)
        group_by_fields      = optional(list(string), [])
      }), null)
    }), null)
    condition_promql = optional(object({
      query    = string
      duration = optional(string, null)
    }), null)
  }))
}

variable "severity" {
  description = "CRITICAL, ERROR, WARNING"
  type        = string
  default     = "WARNING"
}

variable "user_labels" {
  description = "A map of user-defined labels to apply to the alert policy."
  type        = map(string)
  default     = {}
}

variable "notification_channels" {
  description = "notification channels list"
  type        = list(string)
  default     = []
}