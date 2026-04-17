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

variable "k8s" {
  description = "Kubernetes configuration for this project"
  type        = any
  default     = {}
}

variable "s3" {
  description = "S3 configuration for this project"
  type        = any
  default     = {}
}

variable "dns" {
  description = "DNS configuration for this project"
  type        = any
  default     = {}
}

variable "ycrs" {
  description = "A list of yc registries to create in this project"
  type        = any
  default     = {}
}
