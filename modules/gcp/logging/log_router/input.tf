variable "name" {
  type        = string
  description = "name for log router sink"
}

variable "destination" {
  type        = string
  description = "Destination for log router sink, where logs will be sent"
}

variable "filter" {
  type        = string
  description = "Filter for logs, that will select logs to send to the destination"
}

variable "exclusions" {
  description = "Exclusions list"
  type = list(object({
    name        = string
    description = string
    filter      = string
  }))
  default = []
}