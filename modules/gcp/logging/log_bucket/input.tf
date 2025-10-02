variable "project_id" {
  description = "Gcp project id"
  type        = string
}

variable "description" {
  description = "Description"
  type        = string
  default     = ""
}

variable "location" {
  description = "Location for log bucket"
  type        = string
  default     = "global"
}

variable "retention_days" {
  description = "Retention period in days for log bucket"
  type        = number
  default     = 30
  validation {
    condition     = var.retention_days >= 1
    error_message = "Retention period must be at least 1 day"
  }
}

variable "bucket_id" {
  description = "Bucket id for log bucket"
  type        = string
}
