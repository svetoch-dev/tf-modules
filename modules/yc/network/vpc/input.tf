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
  default     = ""
}
