variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "name" {
  description = "The name of the cluster"
  type        = string
}

variable "location" {
  description = "The location (region or zone) for the cluster"
  type        = string
}

variable "node_locations" {
  description = "The list of zones in which the cluster's nodes are located"
  type        = list(string)
  default     = []
}

variable "network" {
  description = "The name or self_link of the Google Compute Engine network to which the cluster is connected"
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The name or self_link of the Google Compute Engine subnetwork to which the cluster is connected"
  type        = string
  default     = null
}

variable "min_master_version" {
  description = "The minimum version of the master"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the cluster"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the cluster."
  type        = bool
  default     = true
}

variable "resource_labels" {
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  type        = map(string)
  default     = {}
}

variable "networking_mode" {
  description = "Determines whether alias IP or routes will be used for pod IPs in the cluster"
  type        = string
  default     = "VPC_NATIVE"
}

variable "remove_default_node_pool" {
  description = "deletes the default node pool upon cluster creation"
  type = bool
  default = true
}

variable "ip_allocation_policy" {
  description = "Configuration of cluster IP allocation"
  type = object({
    cluster_secondary_range_name  = optional(string)
    services_secondary_range_name = optional(string)
    cluster_ipv4_cidr_block       = optional(string)
    services_ipv4_cidr_block      = optional(string)
    stack_type                    = optional(string)
  })
  default = {}
}

variable "private_cluster_config" {
  description = "Configuration for private clusters"
  type = object({
    enable_private_nodes    = optional(bool, true)
    enable_private_endpoint = optional(bool, false)
    master_ipv4_cidr_block  = optional(string)
    master_global_access_config = optional(object({
      enabled = optional(bool, false)
    }), {})
  })
  default = {}
}

variable "master_authorized_networks_config" {
  description = "Configuration for master authorized networks"
  type = object({
    cidr_blocks = optional(list(object({
      cidr_block   = string
      display_name = optional(string)
    })), [])
  })
  default = {}
}

variable "release_channel" {
  description = "Configuration for release channels"
  type = object({
    channel = optional(string, "STABLE")
  })
  default = {}
}

variable "workload_identity_config" {
  description = "Configuration for workload identity"
  type = object({
    workload_pool = optional(string)
  })
  default = {}
}

variable "addons_config" {
  description = "Configuration for GKE addons"
  type = object({
    http_load_balancing = optional(object({
      disabled = optional(bool, false)
    }), {})
    horizontal_pod_autoscaling = optional(object({
      disabled = optional(bool, false)
    }), {})
    network_policy_config = optional(object({
      disabled = optional(bool, false)
    }), {})
    cloudrun_config = optional(object({
      disabled           = optional(bool)
      load_balancer_type = optional(string)
    }), null)
    config_connector_config = optional(object({
      enabled = optional(bool, false)
    }), {})
    dns_cache_config = optional(object({
      enabled = optional(bool, false)
    }), {})
    gce_persistent_disk_csi_driver_config = optional(object({
      enabled = optional(bool, true)
    }), {})
    gcp_filestore_csi_driver_config = optional(object({
      enabled = optional(bool, false)
    }), {})
    gke_backup_agent_config = optional(object({
      enabled = optional(bool, false)
    }), {})
    gcs_fuse_csi_driver_config = optional(object({
      enabled = optional(bool, true)
    }), {})
  })
  default = {}
}

variable "logging_config" {
  description = "Configuration for cluster logging"
  type = object({
    enable_components = optional(list(string), ["SYSTEM_COMPONENTS", "WORKLOADS"])
  })
  default = {}
}

variable "monitoring_config" {
  description = "Configuration for cluster monitoring"
  type = object({
    enable_components  = optional(list(string), ["SYSTEM_COMPONENTS"])
    managed_prometheus = optional(object({
      enabled = optional(bool, false)
    }), {})
  })
  default = {}
}

variable "maintenance_policy" {
  description = "Configuration for maintenance policy"
  type = object({
    recurring_window = optional(object({
      start_time = string
      end_time   = string
      recurrence = string
    }))
    daily_maintenance_window = optional(object({
      start_time = string
    }))
  })
  default = {}
}

variable "network_policy" {
  description = "Configuration for network policy"
  type = object({
    enabled  = optional(bool, false)
    provider = optional(string, "CALICO")
  })
  default = {}
}

variable "database_encryption" {
  description = "Configuration for database encryption"
  type = object({
    state    = optional(string, "DECRYPTED") 
    key_name = optional(string)
  })
  default = {}
}

variable "binary_authorization" {
  description = "Configuration for binary authorization"
  type = object({
    evaluation_mode = optional(string, "DISABLED")
  })
  default = {}
}

variable "cluster_autoscaling" {
  description = "Configuration for cluster autoscaling"
  type = object({
    enabled             = optional(bool, false)
    autoscaling_profile = optional(string, "BALANCED")
    resource_limits = optional(list(object({
      resource_type = string
      minimum       = optional(number)
      maximum       = optional(number)
    })), [])
    auto_provisioning_defaults = optional(object({
      service_account = optional(string)
      oauth_scopes    = optional(list(string))
      management = optional(object({
        auto_repair  = optional(bool)
        auto_upgrade = optional(bool)
      }))
    }))
    auto_provisioning_locations = optional(list(string), [])
  })
  default = {}
}

variable "master_auth" {
  description = "Configuration for master authentication"
  type = object({
    client_certificate_config = optional(object({
      issue_client_certificate = optional(bool, false)
    }), {})
  })
  default = {}
}

variable "authenticator_groups_config" {
  description = "Configuration for RBAC group-based authentication"
  type = object({
    security_group = string
  })
  default = null
}

variable "confidential_nodes" {
  description = "Configuration for confidential nodes"
  type = object({
    enabled = bool
  })
  default = null
}

variable "cost_management_config" {
  description = "Configuration for cost management"
  type = object({
    enabled = bool
  })
  default = null
}

variable "enable_shielded_nodes" {
  description = "Enable Shielded Nodes features on all nodes in this cluster"
  type = bool
  default = false
}

variable "enable_tpu" {
  description = "value"
  type = bool
  default = false
}

variable "initial_node_count" {
  description = "The number of nodes to create in this cluster's default node pool"
  type = number
  default = 0
}

variable "enable_intranode_visibility" {
  description = "Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network"
  type = bool
  default = false
}

variable "vertical_pod_autoscaling" {
  description = "Configuration for vertical pod autoscaling"
  type = object({
    enabled = bool
  })
  default = null
}

variable "default_snat_status" {
  description = "Configuration for default SNAT status"
  type = object({
    disabled = optional(bool, false)
  })
  default = {}
}

variable "dns_config" {
  description = "Configuration for cluster DNS"
  type = object({
    cluster_dns        = optional(string)
    cluster_dns_scope  = optional(string)
    cluster_dns_domain = optional(string)
  })
  default = null
}

variable "gateway_api_config" {
  description = "Configuration for gateway API"
  type = object({
    channel = string
  })
  default = null
}

variable "identity_service_config" {
  description = "Configuration for identity service"
  type = object({
    enabled = bool
  })
  default = null
}

variable "control_plane_endpoints_config" {
  description = "Configuration for control plane endpoints"
  type = object({
    dns_endpoint_config = optional(object({
      allow_external_traffic    = optional(bool, false)
    }))
    ip_endpoints_config = optional(object({
      enabled = optional(bool, true)
    }))
  })
  default = {}
}

variable "timeouts" {
  description = "This resource provides the following Timeouts configuration options"
  type = object({
    create  = optional(string, "45m")
    delete = optional(string, "45m")
    update  = optional(string, "45m")
    read    = optional(string)
  })
  default = {}
}
