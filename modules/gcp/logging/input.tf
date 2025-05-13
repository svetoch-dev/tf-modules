variable "log_bucket" {
  description = "Log bucket"
  type = list(object({
    bucket_id      = string
    location       = optional(string, "global")
    retention_days = optional(number, 30)
  }))
  default = []
}

variable "log_router" {
  description = "Log router"
  type = list(object({
    name = string
    destination = string
    filter = string
    exclusions = list(object({
      name        = string
      description = optional(string, "Default description")
      filter      = string
    }), null)
  }))
  default = []
}