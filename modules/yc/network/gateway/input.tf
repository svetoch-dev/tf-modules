variable "name" {
  description = "NAT gateway name."
  type        = string
}

variable "description" {
  description = "NAT gateway description."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The folder where the NAT resources will be created."
  type        = string
}

variable "labels" {
  description = "A set of key/value label pairs assigned to the NAT gateway."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Custom timeouts for the NAT gateway resource."
  type = object(
    {
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }
  )
  default = null
}
