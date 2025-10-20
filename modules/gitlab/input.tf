variable "domain" {
  description = "Gitlab domain name"
  type        = string
  default     = "gitlab.com"
}

variable "repositories" {
  description = "Gitlab repositories"
  type = map(
    object(
      {
        name = string
        org  = string
        deploy_keys = optional(
          map(
            object(
              {
                name        = string
                public_key  = optional(string, "")
                private_key = optional(string, "")
                read_only   = bool
                create      = optional(bool, false)
              }
            )
          ), {}
        )
        secrets = optional(
          map(
            object(
              {
                name       = string
                text_value = string
              }
            )
          ), {}
        )
        vars = optional(
          map(
            object(
              {
                name  = string
                value = string
              }
            )
          ), {}
        )
      }
    )
  )
}
