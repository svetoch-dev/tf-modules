variable "name" {
  description = "Google pubsub topic name"
  type        = string
}

variable "message_retention_duration" {
  description = "Indicates the minimum duration to retain a message after it is published to the topic. Cannot be more than 31 days or less than 10 minutes"
  type        = string
  default     = ""
}

variable "regions" {
  description = "A list of IDs of GCP regions where messages that are published to the topic may be persisted in storage. Messages published by publishers running in non-allowed GCP regions (or running outside of GCP altogether) will be routed for storage in one of the allowed regions"
  type        = list(string)
  default     = []
}

variable "editors" {
  description = "The list of users who have pubsub.editor rights"
  type        = list(string)
  default     = []
}

variable "publishers" {
  description = "The list of users who have pubsub.publisher rights"
  type        = list(string)
  default     = []
}

variable "subscribers" {
  description = "The list of users who have pubsub.subscriber rights"
  type        = list(string)
  default     = []
}

variable "admins" {
  description = "The list of users who have pubsub.admin rights"
  type        = list(string)
  default     = []
}

variable "viewers" {
  description = "The list of users who have pubsub.viewer rights"
  type        = list(string)
  default     = []
}

variable "subscriptions" {
  description = "A named resources representing the stream of messages from a single, specific topic, to be delivered to the subscribing application"
  type = map(object({
    ttl                               = optional(string, "2678400s")
    minimum_backoff                   = optional(string, null)
    maximum_backoff                   = optional(string, null)
    dead_letter_topic                 = optional(string, null)
    dead_letter_max_delivery_attempts = optional(number, null)
    message_retention_duration        = optional(string, "604800s")
    ack_deadline_seconds              = optional(number, 10)
    enable_exactly_once_delivery      = optional(bool, false)
    retain_acked_messages             = optional(bool, false)
    enable_message_ordering           = optional(bool, false)
    filter                            = optional(string, null)
    editors                           = optional(list(string), [])
    admins                            = optional(list(string), [])
    subscribers                       = optional(list(string), [])
    viewers                           = optional(list(string), [])
  }))
  default = null
}
