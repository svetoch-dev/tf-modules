variable "name" {
  description = "IP address name."
  type        = string
}

variable "description" {
  description = "IP address description."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The folder where the IP address will be created."
  type        = string
}

variable "labels" {
  description = "A set of key/value label pairs assigned to the IP address."
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = "Protect the IP address from accidental deletion."
  type        = bool
  default     = false
}

variable "dns_record" {
  description = "DNS records to attach to the IP address."
  type = list(
    object(
      {
        dns_zone_id = string
        fqdn        = string
        ptr         = optional(bool)
        ttl         = optional(number)
      }
    )
  )
  default = []
}

variable "external_ipv4_address" {
  description = "Configuration of the reserved external IPv4 address."
  type = object(
    {
      zone_id                  = optional(string)
      ddos_protection_provider = optional(string)
      outgoing_smtp_capability = optional(string)
    }
  )
}

variable "timeouts" {
  description = "Custom timeouts for the IP address resource."
  type = object(
    {
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }
  )
  default = null
}
