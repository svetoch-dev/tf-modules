variable "company" {
  description = "Company related info"
  type = object(
    {
      name   = string
      domain = string
    }
  )
}

variable "ci" {
  description = "Ci related info"
  type = object(
    {
      type = string
    }
  )
}

variable "env" {
  description = "Environment description"
  type = object(
    {
      name          = string
      short_name    = string
      initial_start = optional(bool, false)
      cloud = object(
        {
          name         = string
          id           = string
          numeric_id   = optional(string)
          region       = string
          default_zone = string
          multi_region = string
          registry     = string
          buckets = object(
            {
              deletion_protection = bool
            }
          )
        }
      )
      kubernetes = optional(
        object(
          {
            enabled             = bool
            regional            = bool
            deletion_protection = bool
            location            = string
            auth_group          = optional(string, "")
          }
        )
      )
    }
  )
}
