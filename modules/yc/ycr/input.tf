variable "folder_id" {
  type = string
}

variable "name" {
  description = "Name of registry"
  type        = string
}

variable "pullers" {
  description = "An array of identities that will be granted the privilege in the role pullers"
  type        = list(string)
  default     = []
}

variable "pushers" {
  description = "An array of identities that will be granted the privilege in the role pushers"
  type        = list(string)
  default     = []
}

variable "ip_permissions" {
  description = "List of configured CIDRs, from which pull/push is allowed"
  type = object(
    {
      push = optional(list(string), [])
      pull = optional(list(string), [])
    }
  )
  default = null
}
