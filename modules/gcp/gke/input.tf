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
    autoscaling         = optional(object, {})
    management          = optional(object, { auto_repair = true, auto_upgrade = true })
    node_config         = optional(object, {})
    upgrade_settings    = optional(object, { max_surge = 1, max_unavailable = 0 })
    placement_policy    = optional(string)
    queued_provisioning = optional(object)
    network_config      = optional(object)
  }))
  default = {}
}
