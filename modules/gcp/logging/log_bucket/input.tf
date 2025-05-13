variable "location" {
  description = "Location for log bucket"
  type        = string
  default     = "global"
}

variable "retention_days" {
  description = "Retention period in days for log bucket"
  type        = number
  default     = 30
}

variable "bucket_id" {
  description = "Bucket id for log bucket"
  type        = string
}