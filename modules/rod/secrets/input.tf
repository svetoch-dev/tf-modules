variable "remote_state" {
  type = any
}

variable "env" {
  description = "Environment description"
  type = object(
    {
      name       = string
      short_name = string
      cloud = object(
        {
          name = string
        }
      )
      import_secrets = map(
        object(
          {
            name              = string
            k8s_enabled       = optional(bool, true)
            namespace         = optional(string)
            base64_secrets    = optional(bool, false)
            secrets_to_import = list(string)
          }
        )
      )
    }
  )
}

variable "overrides" {
  description = "Cloud attribute overrides"
  type = object(
    {
      secrets = optional(any)
    }
  )
  default = {
    secrets = null
  }
}
