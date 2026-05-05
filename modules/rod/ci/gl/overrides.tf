locals {
  cis_merged = provider::deepmerge::mergo(local.cis, var.overrides.cis)
}

variable "overrides" {
  description = "CIs attribute overrides"
  type = object(
    {
      cis = optional(any)
    }
  )
  default = {
    cis = null
  }
}
