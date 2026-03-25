variable "name" {
  description = "Security group name."
  type        = string
}

variable "description" {
  description = "Security group description."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The folder where the security group will be created."
  type        = string
}

variable "network_id" {
  description = "The network where the security group will be created."
  type        = string
}

variable "labels" {
  description = "A set of key/value label pairs assigned to the security group."
  type        = map(string)
  default     = {}
}

variable "ingress" {
  description = "Ingress rules for the security group."
  type = list(
    object(
      {
        description       = optional(string)
        from_port         = optional(number)
        labels            = optional(map(string))
        port              = optional(number)
        predefined_target = optional(string)
        protocol          = string
        security_group_id = optional(string)
        to_port           = optional(number)
        v4_cidr_blocks    = optional(list(string))
        v6_cidr_blocks    = optional(list(string))
      }
    )
  )
  default = []
}

variable "egress" {
  description = "Egress rules for the security group."
  type = list(
    object(
      {
        description       = optional(string)
        from_port         = optional(number)
        labels            = optional(map(string))
        port              = optional(number)
        predefined_target = optional(string)
        protocol          = string
        security_group_id = optional(string)
        to_port           = optional(number)
        v4_cidr_blocks    = optional(list(string))
        v6_cidr_blocks    = optional(list(string))
      }
    )
  )
  default = []
}

variable "timeouts" {
  description = "Custom timeouts for the security group resource."
  type = object(
    {
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }
  )
  default = null
}
