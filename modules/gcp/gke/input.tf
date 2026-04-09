variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "gke_clusters" {
  description = "A map of GKE clusters to create"
  type = map(object({
    location                          = string
    node_locations                    = optional(list(string), [])
    network                           = optional(string)
    subnetwork                        = optional(string)
    min_master_version                = optional(string)
    description                       = optional(string)
    deletion_protection               = optional(bool, true)
    resource_labels                   = optional(map(string), {})
    networking_mode                   = optional(string, "VPC_NATIVE")
    ip_allocation_policy              = optional(any, {})
    private_cluster_config            = optional(any, {})
    master_authorized_networks_config = optional(any, {})
    release_channel                   = optional(any, { channel = "STABLE" })
    workload_identity_config          = optional(any, {})
    enable_autopilot                  = optional(bool, false)
    addons_config                     = optional(any, {})
    logging_config                    = optional(any, {})
    monitoring_config                 = optional(any, {})
    maintenance_policy                = optional(any, {})
    network_policy                    = optional(any, {})
    database_encryption               = optional(any, { state = "DECRYPTED" })
    binary_authorization              = optional(any, {})
    cluster_autoscaling               = optional(any)
    master_auth                       = optional(any, {})
    authenticator_groups_config       = optional(any)
    confidential_nodes                = optional(any)
    cost_management_config            = optional(any)
    enable_shielded_nodes             = optional(bool, false)
    enable_tpu                        = optional(bool, false)
    initial_node_count                = optional(number, 0)
    enable_intranode_visibility       = optional(bool, false)
    vertical_pod_autoscaling          = optional(any)
    default_snat_status               = optional(any)
    dns_config                        = optional(any)
    gateway_api_config                = optional(any)
    identity_service_config           = optional(any)
    control_plane_endpoints_config    = optional(any)
  }))
  default = {}
}

variable "node_pools" {
  description = "A map of node pools to create"
  type = map(object({
    cluster             = string
    location            = string
    name                = string
    node_locations      = optional(list(string), [])
    initial_node_count  = optional(number, 0)
    node_count          = optional(number)
    max_pods_per_node   = optional(number)
    autoscaling         = optional(object({
      min_node_count       = optional(number)
      max_node_count       = optional(number)
      total_min_node_count = optional(number)
      total_max_node_count = optional(number)
      location_policy      = optional(string)
    }), null)
    management = optional(object({
      auto_repair  = optional(bool, true)
      auto_upgrade = optional(bool, true)
    }), 
    { 
      auto_repair  = true, 
      auto_upgrade = true 
    })
    node_config         = optional(object({
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
    }), {})
    upgrade_settings  = optional(object({
      max_surge       = number
      max_unavailable = number
      strategy        = optional(string)
    }), {
      max_surge = 1, 
      max_unavailable = 0 
    })
    placement_policy  = optional(object({
      type = string
    }), null)
    queued_provisioning = optional(object({
      enabled = bool
    }), null)
    network_config      = optional(object({
      create_pod_range     = optional(bool)
      pod_range            = optional(string)
      pod_ipv4_cidr_block  = optional(string)
      enable_private_nodes = optional(bool)
    }), null)
  }))
  default = {}
}
