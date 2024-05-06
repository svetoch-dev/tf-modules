variable "name" {
  description = "Google pubsub topic name"
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

#variable "readers" {
#  description = "The list of users who have the right to read"
#  type        = list(any)
#  default     = []
#}

#variable "writers" {
#  description = "The list of users who have the right to write"
#  type        = list(any)
#  default     = []
#}

variable "subscriptions" {
  description = "A named resources representing the stream of messages from a single, specific topic, to be delivered to the subscribing application"
  type = map(object({
    name = optional(string)
  }))
  default = null
}
