variable "project_id" {
  description = "GCP Project ID"
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
  type        = bool
  default     = true
}

variable "ip_allocation_policy" {
  description = "Configuration of cluster IP allocation"
  type = object(
    {
      cluster_secondary_range_name  = optional(string)
      services_secondary_range_name = optional(string)
      cluster_ipv4_cidr_block       = optional(string)
      services_ipv4_cidr_block      = optional(string)
      stack_type                    = optional(string)
    }
  )
}

variable "private_cluster_config" {
  description = "Configuration for private clusters"
  type = object(
    {
      enable_private_nodes                = optional(bool, true)
      enable_private_endpoint             = optional(bool, false)
      master_ipv4_cidr_block              = optional(string)
      master_global_access_config_enabled = optional(bool)
    }
  )
  default = {}
}

variable "master_authorized_networks_config" {
  description = "Configuration for master authorized networks"
  type = object(
    {
      cidr_blocks = optional(
        list(
          object(
            {
              cidr_block   = string
              display_name = optional(string)
            }
          )
        ),
        []
      )
    }
  )
  default = null
}

variable "release_channel" {
  description = "Configuration for release channels"
  type        = string
  default     = "STABLE"
}

variable "workload_identity_config_pool" {
  description = "Configuration for workload identity"
  type        = string
  default     = null
}

variable "addons_config" {
  description = "Configuration for GKE addons"
  type = object(
    {
      http_load_balancing_enabled                   = optional(bool, true)
      horizontal_pod_autoscaling_enabled            = optional(bool, true)
      network_policy_config_enabled                 = optional(bool, true)
      config_connector_config_enabled               = optional(bool, false)
      dns_cache_config_enabled                      = optional(bool, false)
      gce_persistent_disk_csi_driver_config_enabled = optional(bool, false)
      gcp_filestore_csi_driver_config_enabled       = optional(bool, false)
      gke_backup_agent_config_enabled               = optional(bool, false)
      gcs_fuse_csi_driver_config_enabled            = optional(bool, false)
      cloudrun_config = optional(
        object(
          {
            enabled            = optional(bool, false)
            load_balancer_type = optional(string)
          }
        ),
        null
      )
    }
  )
  default = {}
}

variable "logging_config_enable_components" {
  description = "Configuration for cluster logging"
  type        = list(string)
  default     = ["SYSTEM_COMPONENTS", "WORKLOADS"]
}

variable "monitoring_config" {
  description = "Configuration for cluster monitoring"
  type = object(
    {
      enable_components = optional(
        list(string),
        [
          "SYSTEM_COMPONENTS"
        ]
      )
      managed_prometheus = optional(
        object(
          {
            enabled = optional(bool, false)
          }
        ),
        {}
      )
  })
  default = {}
}

variable "maintenance_policy" {
  description = "Configuration for maintenance policy"
  type = object(
    {
      recurring_window = optional(
        object(
          {
            start_time = string
            end_time   = string
            recurrence = string
          }
        )
      )
      daily_maintenance_window = optional(
        object(
          {
            start_time = string
          }
        )
      )
    }
  )
  default = null
}

variable "network_policy" {
  description = "Configuration for network policy"
  type = object(
    {
      enabled  = optional(bool, false)
      provider = optional(string, "CALICO")
    }
  )
  default = null
}

variable "database_encryption" {
  description = "Configuration for database encryption"
  type = object(
    {
      state    = optional(string, "DECRYPTED")
      key_name = optional(string)
    }
  )
  default = {}
}

variable "binary_authorization_evaluation_mode" {
  description = "Configuration for binary authorization"
  type        = string
  default     = "DISABLED"
}

variable "cluster_autoscaling" {
  description = "Configuration for cluster autoscaling"
  type = object(
    {
      enabled             = optional(bool, false)
      autoscaling_profile = optional(string, "BALANCED")
      resource_limits = optional(
        list(
          object(
            {
              resource_type = string
              minimum       = optional(number)
              maximum       = optional(number)
            }
          )
        ),
        []
      )
      auto_provisioning_defaults = optional(
        object(
          {
            service_account = optional(string)
            oauth_scopes    = optional(list(string))
            management = optional(
              object(
                {
                  auto_repair  = optional(bool)
                  auto_upgrade = optional(bool)
                }
              )
            )
          }
        )
      )
      auto_provisioning_locations = optional(list(string), [])
    }
  )
  default = null
}

variable "master_auth_issue_client_certificate" {
  description = "Configuration for master authentication"
  type        = bool
  default     = false
}

variable "authenticator_groups_config_security_group" {
  description = "Configuration for RBAC group-based authentication"
  type        = string
  default     = null
}

variable "confidential_nodes" {
  description = "Configuration for confidential nodes"
  type = object(
    {
      enabled = bool
    }
  )
  default = null
}

variable "cost_management_config_enabled" {
  description = "Configuration for cost management"
  type        = bool
  default     = null
}

variable "enable_shielded_nodes" {
  description = "Enable Shielded Nodes features on all nodes in this cluster"
  type        = bool
  default     = false
}

variable "enable_tpu" {
  description = "value"
  type        = bool
  default     = false
}

variable "initial_node_count" {
  description = "The number of nodes to create in this cluster's default node pool"
  type        = number
  default     = 1
}

variable "enable_intranode_visibility" {
  description = "Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network"
  type        = bool
  default     = false
}

variable "vertical_pod_autoscaling_enabled" {
  description = "Configuration for vertical pod autoscaling"
  type        = bool
  default     = true
}

variable "default_snat_status_enabled" {
  description = "Configuration for default SNAT status"
  type        = bool
  default     = true
}

variable "dns_config" {
  description = "Configuration for cluster DNS"
  type = object(
    {
      cluster_dns        = optional(string)
      cluster_dns_scope  = optional(string)
      cluster_dns_domain = optional(string)
    }
  )
  default = null
}

variable "gateway_api_config_channel" {
  description = "Configuration for gateway API"
  type        = string
  default     = null
}

variable "identity_service_config_enabled" {
  description = "Configuration for identity service"
  type        = bool
  default     = false
}

variable "control_plane_endpoints_config" {
  description = "Configuration for control plane endpoints"
  type = object(
    {
      dns_endpoint_config = optional(
        object(
          {
            allow_external_traffic = optional(bool, false)
          }
        )
      )
      ip_endpoints_config_enabled = optional(bool, true)
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

variable "node_pools" {
  description = "A map of node pools to create"
  type = map(
    object(
      {
        name              = optional(string)
        name_prefix       = optional(string, null)
        node_count        = optional(number)
        max_pods_per_node = optional(number)
        autoscaling = optional(
          object(
            {
              min_node_count       = optional(number, 0)
              max_node_count       = optional(number, 1)
              total_min_node_count = optional(number, 0)
              total_max_node_count = optional(number, 0)
              location_policy      = optional(string, "ANY")
            }
          ),
          {}
        )
        management = optional(
          object(
            {
              auto_repair  = optional(bool, true)
              auto_upgrade = optional(bool, true)
            }
          ),
          {}
        )
        node_config = object(
          {
            machine_type    = optional(string, "e2-medium")
            service_account = optional(string)
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
        upgrade_settings = optional(
          object(
            {
              max_surge       = optional(number, 2)
              max_unavailable = optional(number, 0)
              strategy        = optional(string)
            }
          ),
          {}
        )
        queued_provisioning_enabled = optional(bool)
        network_config = optional(
          object(
            {
              create_pod_range     = optional(bool, false)
              pod_range            = optional(string)
              pod_ipv4_cidr_block  = optional(string)
              enable_private_nodes = optional(bool, true)
            }
          ),
          {}
        )
      }
    )
  )
}
