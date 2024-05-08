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
  default     = []
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

variable "admins" {
  description = "The list of users who have pubsub.admin rights"
  type        = list(any)
  default     = []
}

variable "viewers" {
  description = "The list of users who have pubsub.viewer rights"
  type        = list(any)
  default     = []
}

variable "subscriptions" {
  description = "A named resources representing the stream of messages from a single, specific topic, to be delivered to the subscribing application"
  type = map(object({
    message_retention_duration = optional(string, null)
    ack_deadline_seconds       = optional(number, 0)
    retain_acked_messages      = optional(bool, null)
    enable_message_ordering    = optional(bool, null)
    filter                     = optional(string, null)
    editors                    = optional(list(any), [])
    admins                     = optional(list(any), [])
    subscribers                = optional(list(any), [])
    viewers                    = optional(list(any), [])
    cloud_storage = optional(map(object({
      filename_prefix = optional(string, "")
      filename_suffix = optional(string, "")
      max_bytes       = optional(number)
      max_duration    = optional(string, "")
      avro_config = optional(object({
        write_metadata = optional(bool)
      }), null)
    })), null)
  }))
  default = null
}
