variable "name" {
  description = "Google pubsub topic name"
  type        = string
}

variable "message_retention_duration" {
  description = "Indicates the minimum duration to retain a message after it is published to the topic. Cannot be more than 31 days or less than 10 minutes"
  type        = string
}

variable "regions" {
  description = "A list of IDs of GCP regions where messages that are published to the topic may be persisted in storage. Messages published by publishers running in non-allowed GCP regions (or running outside of GCP altogether) will be routed for storage in one of the allowed regions"
  type        = list(string)
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs to assign to this Topic"
  type = map(object({
    value = optional(string)
  }))
  default = null
}

variable "editors" {
  description = "The list of users who have pubsub.editor rights"
  type        = list(any)
  default     = []
}

variable "publishers" {
  description = "The list of users who have pubsub.publisher rights"
  type        = list(any)
  default     = []
}

variable "subscribers" {
  description = "The list of users who have pubsub.subscriber rights"
  type        = list(any)
  default     = []
}

variable "subscriptions" {
  description = "A named resources representing the stream of messages from a single, specific topic, to be delivered to the subscribing application"
  type = map(object({
    editors     = optional(string, [])
    publishers  = optional(string, [])
    subscribers = optional(string, [])
  }))
  default = null
}
