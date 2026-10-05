locals {
  secrets_processed = provider::deepmerge::mergo(local.secrets, var.overrides.secrets)

  secrets_merged = lookup(
    {
      yc = provider::deepmerge::mergo(local.secrets_processed, local.secrets_yc)
    },
    var.env.cloud.name,
    local.secrets_processed
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
