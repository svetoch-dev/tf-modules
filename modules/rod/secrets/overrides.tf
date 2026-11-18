locals {
  secrets_merged = provider::deepmerge::mergo(local.secrets, var.overrides.secrets)
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
