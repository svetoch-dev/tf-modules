variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "cluster" {
  description = "The name of the cluster"
  type        = string
}

variable "location" {
  description = "The location (region or zone) for the cluster"
  type        = string
}

variable "name" {
  description = "The name of the node pool"
  type        = string
}

variable "name_prefix" {
  description = "Creates a unique name for the node pool beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null
}

variable "node_locations" {
  description = "The list of zones in which the cluster's nodes are located"
  type        = list(string)
  default     = []
}

variable "node_count" {
  description = "Number of nodes per zone"
  type        = number
  default     = null
}

variable "max_pods_per_node" {
  description = "The maximum number of pods per node in this node pool"
  type        = number
  default     = null
}

variable "autoscaling" {
  description = "Configuration for node pool autoscaling"
  type = object(
    {
      min_node_count       = optional(number, 0)
      max_node_count       = optional(number, 1)
      total_min_node_count = optional(number, 0)
      total_max_node_count = optional(number, 0)
      location_policy      = optional(string, "ANY")
    }
  )
  default = {}
}

variable "management" {
  description = "Configuration for node pool management"
  type = object(
    {
      auto_repair  = optional(bool, true)
      auto_upgrade = optional(bool, true)
    }
  )
  default = {}
}

variable "node_config" {
  description = "Configuration for node pool nodes"
  type = object(
    {
      machine_type    = optional(string, "e2-medium")
      service_account = string
      oauth_scopes = optional(
        list(string),
        [
          "https://www.googleapis.com/auth/userinfo.email",
          "https://www.googleapis.com/auth/cloud-platform"
        ]
      )
      disk_size_gb = optional(number, 50)
      disk_type    = optional(string, "pd-ssd")
      image_type   = optional(string, "COS_CONTAINERD")
      labels       = optional(map(string), {})
      metadata = optional(
        map(string),
        {
          "disable-legacy-endpoints" = "true"
        }
      )
      tags            = optional(list(string), [])
      preemptible     = optional(bool, false)
      spot            = optional(bool, false)
      local_ssd_count = optional(number, 0)
      taint = optional(
        list(
          object(
            {
              key    = string
              value  = string
              effect = string
            }
          )
        ),
        null
      )
      workload_metadata_config = optional(
        object(
          {
            mode = optional(string, "GKE_METADATA")
          }
        ),
        {}
      )
      shielded_instance_config = optional(
        object(
          {
            enable_secure_boot          = optional(bool, false)
            enable_integrity_monitoring = optional(bool, true)
          }
        ),
        {}
      )
      kubelet_config = optional(
        object(
          {
            allowed_unsafe_sysctls                 = optional(list(string), [])
            container_log_max_files                = optional(number, 0)
            image_gc_high_threshold_percent        = optional(number, 0)
            image_gc_low_threshold_percent         = optional(number, 0)
            insecure_kubelet_readonly_port_enabled = optional(string, "FALSE")
            cpu_cfs_quota                          = optional(bool, false)
            cpu_manager_policy                     = optional(string)
            pod_pids_limit                         = optional(number, 0)
          }
        ),
        {}
      )
      enable_confidential_storage = optional(bool, false)
      flex_start                  = optional(bool, false)
      logging_variant             = optional(string, "DEFAULT")
      resource_manager_tags       = optional(map(string), {})
      storage_pools               = optional(list(string), [])
    }
  )
}

variable "upgrade_settings" {
  description = "Configuration for node pool upgrade settings"
  type = object(
    {
      max_surge       = optional(number, 2)
      max_unavailable = optional(number, 0)
      strategy        = optional(string)
    }
  )
  default = {}
}

variable "queued_provisioning_enabled" {
  description = "Configuration for queued provisioning"
  type        = bool
  default     = null
}

variable "network_config" {
  description = "Configuration for node pool networking"
  type = object(
    {
      create_pod_range     = optional(bool, false)
      pod_range            = optional(string)
      pod_ipv4_cidr_block  = optional(string)
      enable_private_nodes = optional(bool, true)
    }
  )
  default = {}
}

variable "timeouts" {
  description = "This resource provides the following Timeouts configuration options"
  type = object(
    {
      create = optional(string, "45m")
      delete = optional(string, "45m")
      update = optional(string, "45m")
    }
  )
  default = {}
}
