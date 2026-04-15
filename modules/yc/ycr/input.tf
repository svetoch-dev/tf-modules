variable "folder_id" {
  type = string
}

variable "name" {
  description = "Name of registry"
  type        = string
}

variable "timeouts" {
  description = "Custom timeouts for the yandex_container_registry resource"
  type = object(
    {
      create = optional(string)
      update = optional(string)
      delete = optional(string)
      read   = optional(string)
    }
  )
  default = null
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
      write            = optional(list(string), [])
      read             = optional(list(string), [])
      default_timeouts = optional(string)
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
        timeouts = optional(
          object(
            {
              create = optional(string)
              update = optional(string)
              delete = optional(string)
              read   = optional(string)
            }
          ),
          null
        )
        lifecycle_policy = optional(object(
          {
            name             = optional(string)
            status           = optional(string, "active")
            description      = optional(string)
            default_timeouts = optional(string)
            rule = optional(object(
              {
                expire_period = optional(string)
                retained_top  = optional(number)
                description   = optional(string)
                tag_regexp    = optional(string)
                untagged      = optional(bool)
              }
              ),
            null)
          }
          ),
        null)
      }
    )
  )
  default = {}
}
