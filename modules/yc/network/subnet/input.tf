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

variable "ip_cidr_range" {
  description = "Primary IPv4 CIDR block for the subnet."
  type        = string
}

variable "route_table_id" {
  description = "Route table ID to attach to the subnet."
  type        = string
  default     = null
}
