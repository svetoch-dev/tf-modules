variable "name" {
  description = "Google pubsub topic name"
  type        = string
}

variable "message_retention_duration" {
  description = "Indicates the minimum duration to retain a message after it is published to the topic. Cannot be more than 31 days or less than 10 minutes"
  type        = string
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
    editors     = optional(list(any), [])
    admins      = optional(list(any), [])
    subscribers = optional(list(any), [])
    viewers     = optional(list(any), [])
  }))
  default = null
}

variable "cloud_storage" {
  description = "If delivery to Cloud Storage is used with this subscription, this field is used to configure it"
  type = map(object({
    filename_prefix = optional(string, "")
    filename_suffix = optional(string, "")
    max_bytes       = optional(number)
    max_duration    = optional(string, "")
    avro_config = object({
      write_metadata = optional(bool)
    })
    default = null
  }))
  default = null
}
