variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "name" {
  description = "The name of the cluster"
  type        = string
}

variable "regional" {
  description = "Whether is a regional cluster or zonal"
  type        = bool
  default     = true
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = null
}

variable "zones" {
  description = "The zones to host the cluster in"
  type        = list(string)
  default     = []
}

variable "version" {
  description = "The Kubernetes version"
  type        = string
  default     = "latest"
}

variable "network" {
  description = "Network configuration object"
  type        = any
  # Expected keys: network, subnetwork, network_policy, network_policy_provider, 
  # ip_range_pods, ip_range_services, enable_private_nodes, enable_private_endpoint, 
  # master_ipv4_cidr_block, master_authorized_networks
}

variable "features" {
  description = "Features configuration object"
  type        = any
  default     = {}
  # Expected keys: http_load_balancing, horizontal_pod_autoscaling, 
  # enable_vertical_pod_autoscaling, enable_shielded_nodes, 
  # gcs_fuse_csi_driver, authenticator_security_group
}

variable "logging_enabled_components" {
  description = "List of services to monitor"
  type        = list(string)
  default     = ["SYSTEM_COMPONENTS", "WORKLOADS"]
}

variable "security" {
  description = "Security configuration object"
  type        = any
  default     = {}
  # Expected keys: identity_namespace, node_metadata
}

variable "maintenance" {
  description = "Maintenance configuration object"
  type        = any
  default     = {}
  # Expected keys: start_time, recurrence, end_time
}

variable "labels" {
  description = "The GCE resource labels to be applied to the cluster"
  type        = map(string)
  default     = {}
}

variable "node_pools" {
  description = "Map of node pools"
  type        = any
  default     = {}
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the cluster."
  type        = bool
  default     = true
}