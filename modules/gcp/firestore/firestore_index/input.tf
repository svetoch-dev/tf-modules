variable "collection" {
  description = "The collection being indexed"
  type = string
}

variable "fields" {
  description = "An ordered list of properties to index on"
  type = list(
    object(
      {
        field_path = string
        order      = string
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