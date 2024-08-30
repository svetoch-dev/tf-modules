variable "name" {
  description = "Firestore db name"
  type        = string
}

variable "location_id" {
  description = "Firestore db location"
  type        = string
}

variable "type" {
  description = "Firestore db type"
  type        = string
}

variable "concurrency_mode" {
  description = "Firestore db confcurrency mode"
  type        = string
  default     = null
}

variable "app_engine" {
  description = "Firestore db app engine integration mode to use"
  type = object(
    {
      integration_mode = string
      create           = bool
    }
  )
  default = {
    integration_mode = "DISABLED"
    create           = false
  }
}

variable "delete_protection_state" {
  description = "Firestore db delete protection state"
  type        = string
  default     = "DELETE_PROTECTION_DISABLED"
}

variable "deletion_policy" {
  description = "Firestore db deletion behaviour"
  type        = string
  default     = "ABANDON"
}

variable "pitr" {
  description = "Point in time recovery. If True - enabled"
  type        = bool
  default     = false
}

variable "backup" {
  description = "Type of backup. Values: 'daily' for daily backups and 'weekly' for weekly backups"
  type        = string
  default     = "disabled"
  validation {
    condition     = var.backup == "disable" || var.backup == "daily" || var.backup == "weekly"
    error_message = "The backup variable must be one of 'disable', 'daily', or 'weekly'."
  }
}

variable "retention" {
  description = "Retention for Datastore daily back ups"
  type        = string
  default     = "10080s"
}

variable "recurrence_day" {
  description = "Retention for Datastore weekly back ups"
  type        = string
  default     = "SUNDAY"
}




