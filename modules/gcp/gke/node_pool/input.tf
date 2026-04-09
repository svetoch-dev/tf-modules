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

variable "node_locations" {
  description = "The list of zones in which the cluster's nodes are located"
  type        = list(string)
  default     = []
}

variable "initial_node_count" {
  description = "Initial number of nodes in the node pool"
  type        = number
  default     = 0
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
  type = object({
    min_node_count       = optional(number, 0)
    max_node_count       = optional(number, 1)
    total_min_node_count = optional(number, 0)
    total_max_node_count = optional(number, 0)
    location_policy      = optional(string, "ANY")
  })
  default = {}
}

variable "management" {
  description = "Configuration for node pool management"
  type = object({
    auto_repair  = optional(bool, true)
    auto_upgrade = optional(bool, true)
  })
  default = {
    auto_repair  = true
    auto_upgrade = true
  }
}

variable "node_config" {
  description = "Configuration for node pool nodes"
  type = object({
    machine_type    = optional(string, "e2-medium")
    service_account = optional(string, "default")
    oauth_scopes    = optional(list(string), ["https://www.googleapis.com/auth/cloud-platform"])
    disk_size_gb    = optional(number, 100)
    disk_type       = optional(string, "pd-standard")
    image_type      = optional(string, "COS_CONTAINERD")
    labels          = optional(map(string), {})
    metadata        = optional(map(string), {})
    tags            = optional(list(string), [])
    preemptible     = optional(bool, false)
    spot            = optional(bool, false)
    local_ssd_count = optional(number, 0)
    taint = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
    workload_metadata_config = optional(object({
      mode = string
    }))
    shielded_instance_config = optional(object({
      enable_secure_boot          = optional(bool, false)
      enable_integrity_monitoring = optional(bool, true)
    }))
    kubelet_config = optional(object({
      cpu_manager_policy   = optional(string)
      cpu_cfs_quota        = optional(bool)
      cpu_cfs_quota_period = optional(string)
      pod_pids_limit       = optional(number)
    }))
    linux_node_config = optional(object({
      sysctls     = optional(map(string))
      cgroup_mode = optional(string)
    }))
    gvnic = optional(object({
      enabled = bool
    }))
    reservation_affinity = optional(object({
      consume_reservation_type = string
      key                      = optional(string)
      values                   = optional(list(string))
    }))
  })
  default = {}
}

variable "upgrade_settings" {
  description = "Configuration for node pool upgrade settings"
  type = object({
    max_surge       = number
    max_unavailable = number
    strategy        = optional(string)
  })
  default = {
    max_surge       = 1
    max_unavailable = 0
  }
}

variable "placement_policy" {
  description = "Configuration for node placement policy"
  type = object({
    type = string
  })
  default = null
}

variable "queued_provisioning" {
  description = "Configuration for queued provisioning"
  type = object({
    enabled = bool
  })
  default = null
}

variable "network_config" {
  description = "Configuration for node pool networking"
  type = object({
    create_pod_range     = optional(bool, false)
    pod_range            = optional(string)
    pod_ipv4_cidr_block  = optional(string)
    enable_private_nodes = optional(bool, true)
  })
  default = {}
}
