variable "name" {
  description = "Alloydb instance id"
  type        = string
}

variable "instance_type" {
  description = "Alloydb instance type PRIMARY/SECONDARY/READ_POOL"
  type        = string
}

variable "gce_zone" {
  description = "Alloydb instance zone when availability type is zonal"
  type        = string
  default     = ""
}

variable "cluster" {
  description = "Alloydb cluster id projects/{project}/locations/{location}/clusters/{cluster_id}'"
  type        = string
}

variable "availability_type" {
  description = "Alloydb instance availability type - ZONAL/REGIONAL"
  type        = string
}

variable "machine_config" {
  description = "Alloydb instance machine configuration"
  type = object(
    {
      cpu_count    = number
      machine_type = optional(string)
    }
  )
}

variable "labels" {
  description = "Alloydb instance labels"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Alloydb instance annotations"
  type        = map(string)
  default     = {}
}

variable "database_flags" {
  description = "Alloydb instance database_flags"
  type        = map(string)
  default     = {}
}

variable "display_name" {
  description = "Alloydb instance display name"
  type        = string
  default     = ""
}

variable "query_insights" {
  description = "Postgres query analtics configuration"
  type = object(
    {
      query_string_length     = optional(number, 1024)
      record_application_tags = optional(string, "on")
      record_client_address   = optional(string, "on")
      query_plans_per_minute  = optional(number, 5)
    }
  )
  default = {
    query_string_length     = 1024
    record_application_tags = "on"
    record_client_address   = "on"
    query_plans_per_minute  = 5
  }
}

variable "read_pool" {
  description = "Alloydb instance readonly configuration"
  type = object(
    {
      node_count = number
    }
  )
  default = null
}

variable "network" {
  description = "Alloydb instance network configuration"
  type = object(
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
  default = null
}
