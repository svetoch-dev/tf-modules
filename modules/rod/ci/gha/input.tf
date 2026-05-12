variable "bazelisk_image" {
  description = "bazelisk image url"
  type        = string
}

variable "repo" {
  description = "git infrastructure repository related info"
  type = object(
    {
      name  = string
      type  = string
      group = string
    }
  )
}

variable "app_env_ci_configs" {
  description = "list of CI configurations for application in environment"
  type = list(
    object(
      {
        app_name = string
        cd = optional(
          object(
            {
              branch   = optional(string)
              file     = optional(string)
              tag_path = optional(string)
            }
          ),
          {
            branch   = null
            file     = null
            tag_path = null
          }
        )
        env = object(
          {
            short_name   = string
            registry_url = optional(string)
          }
        )
        repo = object(
          {
            name  = string
            group = optional(string)
          }
        )
      }
    )
  )
}
