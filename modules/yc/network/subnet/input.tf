variable "name" {
  description = "Subnet name."
  type        = string
}

variable "description" {
  description = "Subnet description."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The folder where the subnet will be created."
  type        = string
}

variable "zone" {
  description = "Subnet zone."
  type        = string
}

variable "network_id" {
  description = "The VPC network ID."
  type        = string
}

variable "labels" {
  description = "A set of key/value label pairs assigned to the subnet."
  type        = map(string)
  default     = {}
}

variable "ip_cidr_ranges" {
  description = "IPv4 CIDR blocks for the subnet."
  type        = list(string)
}

variable "dhcp_options" {
  description = "Options for DHCP clients in the subnet."
  type = object({
    domain_name         = optional(string)
    domain_name_servers = optional(list(string))
    ntp_servers         = optional(list(string))
  })
  default = null
}

variable "route_table_id" {
  description = "Route table ID to attach to the subnet."
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Custom timeouts for the subnet resource."
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}
