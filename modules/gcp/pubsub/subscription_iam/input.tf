variable "name" {
  description = "The name of subscription"
  type        = string
}

variable "editors" {
  description = "The list of users who have pubsub.editor rights"
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
