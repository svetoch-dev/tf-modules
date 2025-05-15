variable "name" {
  type        = string
  description = "name for log router sink"
}

variable "filter" {
  type        = string
  description = "Filter for logs, that will select logs to send to the destination"
}

variable "exclusions" {
  description = "Exclusions list"
  type = map(object({
    description = string
    filter      = string
    disabled    = optional(bool, false)
  }))
  default = {}
}

variable "gcs_bucket_name" {
  type        = string
  default     = null
  description = "GCS bucket name for storage destination"
}

variable "bq_dataset_name" {
  type        = string
  default     = null
  description = "BigQuery dataset name for destination"
}

variable "log_bucket_name" {
  type        = string
  default     = null
  description = "Log bucket name for logging destination"
}

variable "pubsub_topic_id" {
  type        = string
  default     = null
  description = "Pub/Sub topic ID for destination"
}

variable "disabled" {
  type = bool
  default = false
  description = "If set to True, then this sink is disabled and it does not exclude any log entries."
}