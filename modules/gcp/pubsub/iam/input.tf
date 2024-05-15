variable "name" {
  description = "The name of topic or subscription"
  type        = string
}

variable "is_topic" {
  description = "The variable indicates whether it is a topic or no"
  type        = bool
  default     = false
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

variable "publishers" {
  description = "The list of users who have pubsub.publisher rights to topic"
  type        = list(string)
  default     = []
}
