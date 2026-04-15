variable "folder_id" {
  type = string
}

variable "name" {
  description = "Name of registry"
  type        = string
}

variable "readers" {
  description = "An array of identities that will be granted the privilege in the role pullers"
  type        = list(string)
  default     = []
}

variable "writers" {
  description = "An array of identities that will be granted the privilege in the role pushers"
  type        = list(string)
  default     = []
}

variable "ip_permissions" {
  description = "List of configured CIDRs, from which pull/push is allowed"
  type = object(
    {
      write = optional(list(string), [])
      read  = optional(list(string), [])
    }
  )
  default = null
}

variable "repositories" {
  description = "Map of repositories inside registry"
  type = map(
    object(
      {
        writers = optional(list(string), [])
        readers = optional(list(string), [])
      }
    )
  )
  default = {}
}
