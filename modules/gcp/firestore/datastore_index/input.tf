variable "kind" {
  description = "The entity kind which the index applies to."
}

variable "properties" {
  description = "An ordered list of properties to index on"
  type = list(
    object(
      {
        name      = string
        direction = string
      }
    )
  )
}

variable "timeouts" {
  description = "timeouts for index job"
  type = object({
    create = optional(string, "90m")
    delete = optional(string, "90m")
  })
  default = {
    create = "90m"
    delete = "90m"
  }
}