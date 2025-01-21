variable "name" {
  type        = string
  description = "Channel name"
}

variable "type" {
  type        = string
  description = "Channel type, one of [email, slack, campfire, google_chat, hipchat, pagerduty, pubsub, sms, webhook_basicauth, webhook_tokenauth]"
}

variable "labels" {
  type        = map(string)
  description = "Needet labels for notification channel. For everyone channel need some specify labels. More info in https://cloud.google.com/monitoring/alerts/using-channels-api"
  default     = {}
}

variable "sensitive_labels" {
  description = "Sensitive labels for the notification channel, such as auth tokens, passwords, or service keys."
  type = object({
    auth_token  = optional(string)
    password    = optional(string)
    service_key = optional(string)
  })
  default = {
    auth_token  = null # Required for slack
    password    = null
    service_key = null
  }
}