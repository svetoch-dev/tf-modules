module "cluster" {
  source = "./cluster"

  for_each = var.k8s_cluster

  project_id                        = var.project_id
  name                              = each.key
  location                          = each.value.location
  node_locations                    = each.value.node_locations
  network                           = each.value.network
  subnetwork                        = each.value.subnetwork
  min_master_version                = each.value.min_master_version
  description                       = each.value.description
  deletion_protection               = each.value.deletion_protection
  resource_labels                   = each.value.resource_labels
  networking_mode                   = each.value.networking_mode
  ip_allocation_policy              = each.value.ip_allocation_policy
  private_cluster_config            = each.value.private_cluster_config
  master_authorized_networks_config = each.value.master_authorized_networks_config
  release_channel                   = each.value.release_channel
  workload_identity_config_pool     = each.value.workload_identity_config_pool
  addons_config                     = each.value.addons_config
  logging_config                    = each.value.logging_config
  monitoring_config                 = each.value.monitoring_config
  maintenance_policy                = each.value.maintenance_policy
  network_policy                    = each.value.network_policy
  database_encryption               = each.value.database_encryption
  binary_authorization              = each.value.binary_authorization
  cluster_autoscaling               = each.value.cluster_autoscaling
  master_auth                       = each.value.master_auth
  authenticator_groups_config       = each.value.authenticator_groups_config
  confidential_nodes                = each.value.confidential_nodes
  cost_management_config            = each.value.cost_management_config
  enable_shielded_nodes             = each.value.enable_shielded_nodes
  enable_tpu                        = each.value.enable_tpu
  initial_node_count                = each.value.initial_node_count
  vertical_pod_autoscaling_enabled  = each.value.vertical_pod_autoscaling_enabled
  default_snat_status               = each.value.default_snat_status
  dns_config                        = each.value.dns_config
  gateway_api_config                = each.value.gateway_api_config
  identity_service_config           = each.value.identity_service_config
  control_plane_endpoints_config    = each.value.control_plane_endpoints_config
  timeouts                          = each.value.timeouts
}

module "node_pool" {
  source = "./node_pool"

  for_each = var.cluster.node_pools

  project_id  = var.project_id
  cluster     = each.value.cluster
  location    = each.value.location
  name        = each.value.name
  name_prefix = each.value.name_prefix

  node_locations    = each.value.node_locations
  node_count        = each.value.node_count
  max_pods_per_node = each.value.max_pods_per_node

  autoscaling = each.value.autoscaling
  management  = each.value.management
  node_config = each.value.node_config

  upgrade_settings    = each.value.upgrade_settings
  placement_policy    = each.value.placement_policy
  queued_provisioning = each.value.queued_provisioning
  network_config      = each.value.network_config
  timeouts            = each.value.timeouts

  depends_on = [
    module.cluster
  ]
}
