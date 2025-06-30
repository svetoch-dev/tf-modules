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
  description = "Alloydb cluster type PRIMARY/SECONDARY"
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
  default = null
}

variable "initial_user" {
  description = "Alloydb cluster initial user"
  type = object(
    {
      user     = string
      password = optional(string, null)
    }
  )
  default = null
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
        user_id        = string
        user_type      = optional(string, "ALLOYDB_BUILT_IN")
        database_roles = optional(list(string))
        password       = optional(string)
      }
    )
  )
  default = {}
}

variable "instances" {
  description = "Alloydb instances"
  type = map(
    object(
      {
        name              = string
        instance_type     = string
        labels            = optional(map(string), {})
        annotations       = optional(map(string), {})
        database_flags    = optional(map(string), {})
        availability_type = optional(string)
        gce_zone          = optional(string)
        display_name      = optional(string)

        machine_config = object(
          {
            cpu_count    = number
            machine_type = optional(string)
          }
        )

        query_insights = optional(
          object(
            {
              query_string_length     = optional(number, 1024)
              record_application_tags = optional(bool, true)
              record_client_address   = optional(bool, true)
              query_plans_per_minute  = optional(number, 5)
            }
          ),
          {
            query_string_length     = 1024
            record_application_tags = true
            record_client_address   = true
            query_plans_per_minute  = 5
          }
        )


        read_pool = optional(
          object(
            {
              node_count = number
            }
          )
        )

        client_connection_config = optional(
          object(
            {
              require_connectors = optional(bool, false)
              ssl_config = optional(
                object(
                  {
                    ssl_mode = string
                  }
                )
              )
            }
          )
        )

        network = optional(
          object(
            {
              authorized_external_networks = list(
                object(
                  {
                    cidr_range = string
                  }
                )
              )
              enable_public_ip          = bool
              enable_outbound_public_ip = optional(bool, false)
            }
          )
        )
      }
    )
  )
  default = {}
}
