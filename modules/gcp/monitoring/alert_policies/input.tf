variable "display_name" {
  description = "The display name of the alert policy."
  type        = string
}

variable "combiner" {
  description = "The combiner for the alert policy (AND, OR or AND_WITH_MATCHING_RESOURCE)."
  type        = string
  default     = "OR"
}

variable "alert_strategy" {
  description = "A list of alert strategies for the alert policy."
  type = list(object({
    auto_close           = string
  }))
  default = []
}

variable "conditions" {
  description = "A list of conditions for the alert policy."
  type = list(object({
    display_name    = string
    filter          = string
    duration        = string
    comparison      = string
    threshold_value = number
    trigger_count   = number
    aggregation = object({
      alignment_period     = string
      per_series_aligner   = string
      cross_series_reducer = string
      group_by_fields      = list(string)
    })
  }))
  default = []
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