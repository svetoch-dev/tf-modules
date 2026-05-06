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

variable "ci_vars" {
  description = "CI variables for apps"
  type = list(
    object(
      {
        ci_name        = string
        env_short_name = string
        ci_data = object(
          {
            repo_name  = string
            repo_group = string
            cd_branch  = optional(string)
            cd_file    = optional(string)
            cd_path    = optional(string)
            vars = optional(
              list(
                object(
                  {
                    name  = string
                    value = string
                  }
                )
              ), []
            )
            secrets = optional(
              list(
                object(
                  {
                    name  = string
                    value = string
                  }
                )
              ), []
            )
          }
        )
      }
    )
  )
}
