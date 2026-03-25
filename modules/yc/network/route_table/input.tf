variable "name" {
  description = "Route table name."
  type        = string
}

variable "folder_id" {
  description = "The folder where the route table will be created."
  type        = string
}

variable "network_id" {
  description = "The network where the route table will be created."
  type        = string
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
