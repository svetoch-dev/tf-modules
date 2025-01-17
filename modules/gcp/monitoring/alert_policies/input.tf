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
    condition_treshhold = optional(object({
      filter               = string
      duration             = string
      comparison           = string
      threshold_value      = number
      trigger_count        = optional(number, 1)
      trigger_percent      = optional(number, null)
      alignment_period     = optional(string, "60s")
      per_series_aligner   = optional(string, null)
      cross_series_reducer = optional(string, null)
      group_by_fields      = optional(list(string), [])
    }), null)
    conditions_promql = optional(object({
      query    = string
      duration = optional(string, null)
    }))
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