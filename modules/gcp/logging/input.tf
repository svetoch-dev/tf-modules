variable "log_bucket" {
  description = "Log bucket"
  type = map(object({
    location       = optional(string, "global")
    retention_days = optional(number, 30)
  }))
  default = {}
}

variable "log_router" {
  description = "Log router"
  type = map(object({
    gcs_bucket_name = optional(string)
    bq_dataset_name = optional(string)
    log_bucket_name = optional(string)
    pubsub_topic_id = optional(string)
    filter = string
    exclusions = optional(map(object({
      description = optional(string, "Default description")
      filter      = string
    })), [])
  }))
  default = {}
}