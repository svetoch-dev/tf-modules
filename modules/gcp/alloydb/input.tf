variable "name" {
  description = "Alloydb cluster id"
  type        = string
}

variable "region" {
  description = "gcp region"
  type        = string
}

variable "database_version" {
  description = "postgresql version"
  type        = string
  default     = "POSTGRES_17"
}

variable "labels" {
  description = "Alloydb cluster labels"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Alloydb cluster annotations"
  type        = map(string)
  default     = {}
}

variable "cluster_type" {
  description = "Alloydb cluster type"
  type        = string
  default     = "PRIMARY"
}

variable "project_id" {
  description = "gcp project id"
  type        = string
}

variable "subscription_type" {
  description = "Alloydb cluster subsription type TRIAL/STANDARD."
  type        = string
  default     = "STANDARD"
}

variable "deletion_policy" {
  description = "Alloydb cluter deletion policy DEFAULT/FORCE"
  type        = string
  default     = "DEFAULT"
}

variable "encryption_config" {
  description = "Alloydb cluster encryption config"
  type = object(
    {
      kms_key = string
    }
  )
  default = {}
}

variable "network_config" {
  description = "Alloydb cluster network config"
  type = object(
    {
      network            = string
      allocated_ip_range = optional(string)
    }
  )
  default = null
}

variable "restore_continuous_backup_source" {
  description = "Alloydb cluster restore configs using continuous backup"
  type = object(
    {
      cluster       = string
      point_in_time = string
    }
  )
  default = null
}

variable "continuous_backup_config" {
  description = "Alloydb cluster continuous backup configs"
  type = object(
    {
      enabled              = optional(bool, true)
      recovery_window_days = optional(number, 14)
      encryption_config = optional(
        object(
          {
            kms_key = string
          }
        )
      )
    }
  )
  default = null
}

variable "users" {
  description = "Alloydb cluster users"
  type = map(
    object(
      {
        name           = string
        type           = optional(string, "ALLOYDB_BUILT_IN")
        database_roles = optional(list(string))
      }
    )
  )
  default = null
}
