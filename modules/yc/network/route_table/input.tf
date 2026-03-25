variable "name" {
  description = "Route table name."
  type        = string
}

variable "description" {
  description = "Route table description."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The folder where the route table will be created."
  type        = string
}

variable "network_id" {
  description = "The network where the route table will be created."
  type        = string
}

variable "labels" {
  description = "A set of key/value label pairs assigned to the route table."
  type        = map(string)
  default     = {}
}

variable "static_routes" {
  description = "Static routes to create in the route table."
  type = list(
    object(
      {
        destination_prefix = string
        gateway_id         = optional(string)
        next_hop_address   = optional(string)
      }
    )
  )
  default = []
}

variable "timeouts" {
  description = "Custom timeouts for the route table resource."
  type = object(
    {
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }
  )
  default = null
}
