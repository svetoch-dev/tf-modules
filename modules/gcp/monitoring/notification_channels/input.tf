variable "name" {
  type = string
  description = "Channel name"
}

variable "type" {
  type = string
  description = "Channel type, one of [email, slack, campfire, google_chat, hipchat, pagerduty, pubsub, sms, webhook_basicauth, webhook_tokenauth]"
}

variable "labels" {
  type = map(string)
  description = "Needet labels for notification channel. For everyone channel need some specify labels. More info in https://cloud.google.com/monitoring/alerts/using-channels-api"
  default = {}
}