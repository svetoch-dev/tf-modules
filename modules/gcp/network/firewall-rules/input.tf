variable "network" {
  type = string
}

variable "rules" {
  type = map(
    object(
      {
        direction               = string
        source_ranges           = optional(list(string))
        source_service_accounts = optional(list(string))
        source_tags             = optional(list(string))
        target_tags             = list(string)
        description             = optional(string, "Managed by terraform")
        allow = optional(
          map(
            object(
              {
                ports = list(string)
              }
            )
          )
        )
        deny = optional(
          map(
            object(
              {
                ports = list(string)
              }
            )
          )
        )
      }
    )
  )
}
