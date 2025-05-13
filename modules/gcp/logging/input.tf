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
    description = string
    filter = string
    exclusions = list(object({
      name        = string
      description = string
      filter      = string
    }), null)
  }))
  default = []
}