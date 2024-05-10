variable "name" {
  description = "The name of topic or subscription"
  type        = string
}

variable "editors" {
  description = "The list of users who have pubsub.editor rights to subscription"
  type        = list(string)
  default     = []
}

variable "subscribers" {
  description = "The list of users who have pubsub.subscriber rights to subscription"
  type        = list(string)
  default     = []
}

variable "admins" {
  description = "The list of users who have pubsub.admin rights to subscription"
  type        = list(string)
  default     = []
}

variable "viewers" {
  description = "The list of users who have pubsub.viewer rights to subscription"
  type        = list(string)
  default     = []
}

variable "topic_editors" {
  description = "The list of users who have pubsub.editor rights to topic"
  type        = list(string)
  default     = []
}

variable "topic_publishers" {
  description = "The list of users who have pubsub.publisher rights to topic"
  type        = list(string)
  default     = []
}

variable "topic_subscribers" {
  description = "The list of users who have pubsub.subscriber rights to topic"
  type        = list(string)
  default     = []
}

variable "topic_admins" {
  description = "The list of users who have pubsub.admin rights to topic"
  type        = list(string)
  default     = []
}

variable "topic_viewers" {
  description = "The list of users who have pubsub.viewer rights to topic"
  type        = list(string)
  default     = []
}
