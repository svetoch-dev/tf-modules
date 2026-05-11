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

variable "ci_configs" {
  description = "list of CI configurations for application in environment"
  type = list(
    object(
      {
        ci_name          = string
        env_short_name   = string
        env_registry_url = optional(string, "")
        repo = object(
          {
            name  = string
            group = optional(string)
          }
        )
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
      }
    )
  )
}
