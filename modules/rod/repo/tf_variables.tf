variable "company" {
  description = "Company related info"
  type = object(
    {
      name   = string
      domain = string
    }
  )
}

variable "ci" {
  description = "Ci related info"
  type = object(
    {
      type = string
      group = string
    }
  )
  default = null
}


variable "overrides" {
  description = "Repositories attribute overrides"
  type = object(
    {
      repositories = optional(any)
    }
  )
  default = {
    repositories = null
  }
}
