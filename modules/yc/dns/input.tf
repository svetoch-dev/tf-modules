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

variable "admins" {
  description = "IAM member strings that should receive the dns.admin role. Must use Yandex Cloud IAM member format such as 'serviceAccount:<id>', 'userAccount:<login>', 'group:<id>' etc."
  type        = list(string)
  default     = []
}

variable "viewers" {
  description = "IAM member strings that should receive the dns.viewer role. Must use Yandex Cloud IAM member format such as 'serviceAccount:<id>', 'userAccount:<login>', 'group:<id>' etc."
  type        = list(string)
  default     = []
}

variable "editors" {
  description = "IAM member strings that should receive the dns.editor role. Must use Yandex Cloud IAM member format such as 'serviceAccount:<id>', 'userAccount:<login>', 'group:<id>' etc."
  type        = list(string)
  default     = []
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

variable "records" {
  description = "List of DNS record sets to create in the zone."
  type = list(
    object(
      {
        name = string
        type = string
        ttl  = number
        data = list(string)
        timeouts = optional(
          object(
            {
              create = optional(string)
              update = optional(string)
              delete = optional(string)
            }
          )
        )
      }
    )
  )
  default = []
}
