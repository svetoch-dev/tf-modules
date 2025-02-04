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
        name     = string
        type     = string
        value    = optional(string)
        ttl      = optional(number, 1) #1 is automatic ttl
        proxied  = optional(bool, false)
        priority = optional(number)
        data = optional(
          object(
            {
              service  = optional(string)
              name     = optional(string)
              proto    = optional(string)
              target   = optional(string)
              port     = optional(number)
              weight   = optional(number)
              priority = optional(number)
            }
          )
        )
      }
    )
  )
}
