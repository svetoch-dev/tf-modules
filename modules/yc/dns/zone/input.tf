variable "folder_id" {
  description = "The folder where the DNS zone will be created."
  type        = string
}

variable "name" {
  description = "DNS zone name."
  type        = string
}

variable "zone" {
  description = "DNS zone domain, typically ending with a trailing dot."
  type        = string
}

variable "description" {
  description = "DNS zone description."
  type        = string
  default     = ""
}

variable "labels" {
  description = "A set of key/value label pairs assigned to the DNS zone."
  type        = map(string)
  default     = {}
}

variable "public" {
  description = "Whether the DNS zone should be publicly visible."
  type        = bool
  default     = true
}

variable "private_networks" {
  description = "VPC network IDs attached to the DNS zone when using private visibility."
  type        = list(string)
  default     = []
}

variable "deletion_protection" {
  description = "Protect the DNS zone from accidental deletion."
  type        = bool
  default     = false
}

variable "iam_roles" {
  description = "IAM roles to grant for the DNS zone. Members must use standard Yandex Cloud IAM member formats accepted by the provider."
  type = list(
    object(
      {
        role    = string
        members = list(string)
      }
    )
  )
  default = []
}

variable "timeouts" {
  description = "Custom timeouts for the DNS zone resource."
  type = object(
    {
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }
  )
  default = null
}
