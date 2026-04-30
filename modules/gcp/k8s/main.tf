module "cluster" {
  source = "./cluster"

  project_id                                 = var.project_id
  name                                       = var.name
  location                                   = var.location
  node_locations                             = var.node_locations
  network                                    = var.network
  subnetwork                                 = var.subnetwork
  min_master_version                         = var.min_master_version
  description                                = var.description
  deletion_protection                        = var.deletion_protection
  resource_labels                            = var.resource_labels
  networking_mode                            = var.networking_mode
  remove_default_node_pool                   = var.remove_default_node_pool
  ip_allocation_policy                       = var.ip_allocation_policy
  private_cluster_config                     = var.private_cluster_config
  master_authorized_networks_config          = var.master_authorized_networks_config
  release_channel                            = var.release_channel
  workload_identity_config_pool              = var.workload_identity_config_pool
  addons_config                              = var.addons_config
  logging_config_enable_components           = var.logging_config_enable_components
  monitoring_config                          = var.monitoring_config
  maintenance_policy                         = var.maintenance_policy
  network_policy                             = var.network_policy
  database_encryption                        = var.database_encryption
  binary_authorization_evaluation_mode       = var.binary_authorization_evaluation_mode
  cluster_autoscaling                        = var.cluster_autoscaling
  master_auth_issue_client_certificate       = var.master_auth_issue_client_certificate
  authenticator_groups_config_security_group = var.authenticator_groups_config_security_group
  confidential_nodes                         = var.confidential_nodes
  cost_management_config_enabled             = var.cost_management_config_enabled
  enable_shielded_nodes                      = var.enable_shielded_nodes
  enable_tpu                                 = var.enable_tpu
  initial_node_count                         = var.initial_node_count
  vertical_pod_autoscaling_enabled           = var.vertical_pod_autoscaling_enabled
  default_snat_status_enabled                = var.default_snat_status_enabled
  dns_config                                 = var.dns_config
  gateway_api_config_channel                 = var.gateway_api_config_channel
  identity_service_config_enabled            = var.identity_service_config_enabled
  control_plane_endpoints_config             = var.control_plane_endpoints_config
  timeouts                                   = var.timeouts
}

module "node_pool" {
  for_each = {
    for node_pool_name, node_pool_obj in var.node_pools :
    "${var.name}/${node_pool_name}" => node_pool_obj
    if node_pool_obj != null
  }
  source = "./node_pool"

  project_id                  = var.project_id
  cluster                     = var.name
  location                    = var.location
  name                        = each.value.name
  name_prefix                 = each.value.name_prefix
  node_locations              = each.value.node_locations == null ? var.node_locations : each.value.node_locations
  node_count                  = each.value.node_count
  max_pods_per_node           = each.value.max_pods_per_node
  autoscaling                 = each.value.autoscaling
  management                  = each.value.management
  node_config                 = each.value.node_config
  upgrade_settings            = each.value.upgrade_settings
  queued_provisioning_enabled = each.value.queued_provisioning_enabled
  network_config              = each.value.network_config
  timeouts                    = var.timeouts
  depends_on = [
    module.cluster
  ]
}
