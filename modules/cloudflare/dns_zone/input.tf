variable "zone" {
  description = "Zone description"
  type = object(
    {
      account_id = string
      type       = optional(string, "full")
      name       = string
    }
  )
}

variable "records" {
  description = "list of records in zone"
  type = list(
    object(
      {
        name      = string
        ttl       = optional(number, 1) #1 is automatic ttl
        type      = string
        proxied   = optional(bool, true)
        value     = string
        pritority = optional(number)
      }
    )
  )
}
