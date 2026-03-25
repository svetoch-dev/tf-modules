variable "folder_id" {
  description = "The ID of the folder where this VPC will be created."
  type        = string
}

variable "network_name" {
  description = "The name of the network being created."
  type        = string
}

variable "description" {
  type        = string
  description = "An optional description of this resource."
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs assigned to the network."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Custom timeouts for the VPC network resource."
  type = object(
    {
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }
  )
  default = null
}
