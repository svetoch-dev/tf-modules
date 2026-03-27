variable "project" {
  description = "Project configuration"
  type = object({
    id        = string
    folder_id = string
    region    = string
    zone      = string
  })
}

variable "networks" {
  description = "Networking configuration for this project"
  type        = any
  default     = {}
}
