locals {
  repos_merged = provider::deepmerge::mergo(local.repos, var.overrides.repos)
}

variable "overrides" {
  description = "Repositories attribute overrides"
  type = object(
    {
      repos = optional(any)
    }
  )
  default = {
    repos = null
  }
}
