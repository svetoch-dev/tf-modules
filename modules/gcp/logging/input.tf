variable "log_bucket" {
  description = "Log bucket"
  type = list(object({
    bucket_id      = string
    location       = optional(string, "global")
    retention_days = optional(number, 30)
  }))
  default = []
}