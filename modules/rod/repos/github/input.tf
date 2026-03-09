variable "repo" {
  description = "git repository related info"
  type = object(
    {
      name  = string
      type  = string
      group = string
    }
  )
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
