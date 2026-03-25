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

variable "ip_cidr_ranges" {
  description = "IPv4 CIDR blocks for the subnet."
  type        = list(string)
}

variable "route_table_id" {
  description = "Route table ID to attach to the subnet."
  type        = string
  default     = null
}
