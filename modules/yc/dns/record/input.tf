variable "zone_id" {
  description = "The DNS zone ID where the record set will be managed."
  type        = string
}

variable "name" {
  description = "Record set name."
  type        = string
}

variable "type" {
  description = "DNS record type."
  type        = string
}

variable "ttl" {
  description = "TTL for the record set, in seconds."
  type        = number
  default     = 300
}

variable "data" {
  description = "List of record values for the record set."
  type        = list(string)
}

variable "timeouts" {
  description = "Custom timeouts for the DNS record set resource."
  type = object(
    {
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }
  )
  default = null
}
