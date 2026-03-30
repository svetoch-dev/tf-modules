variable "project" {
  description = "Project configuration"
  type = object({
    id        = string
    folder_id = string
    region    = string
    zone      = string
  })
}

variable "iam" {
  description = "Yandex cloud project iam definition more info in submodule ./iam"
  type = object(
    {
      service_accounts = optional(any, {})
      roles            = optional(any, {})
    }
  )
  default = {
    service_accounts = {}
    roles            = {}
  }
}

variable "networks" {
  description = "Networking configuration for this project"
  type        = any
  default     = {}
}
