resource "google_container_cluster" "cluster" {
  project  = var.project_id
  name     = var.name
  location = var.location

  node_locations = var.node_locations

  network    = var.network
  subnetwork = var.subnetwork

  min_master_version = var.min_master_version
  description        = var.description

  deletion_protection = var.deletion_protection
  resource_labels     = var.resource_labels

  networking_mode = var.networking_mode

  # We create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  dynamic "ip_allocation_policy" {
    for_each = var.ip_allocation_policy != null && length(var.ip_allocation_policy) > 0 ? [var.ip_allocation_policy] : []
    content {
      cluster_secondary_range_name  = ip_allocation_policy.value.cluster_secondary_range_name
      services_secondary_range_name = ip_allocation_policy.value.services_secondary_range_name
      cluster_ipv4_cidr_block       = ip_allocation_policy.value.cluster_ipv4_cidr_block
      services_ipv4_cidr_block      = ip_allocation_policy.value.services_ipv4_cidr_block
      stack_type                    = ip_allocation_policy.value.stack_type
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.private_cluster_config != null && length(var.private_cluster_config) > 0 ? [var.private_cluster_config] : []
    content {
      enable_private_nodes    = private_cluster_config.value.enable_private_nodes
      enable_private_endpoint = private_cluster_config.value.enable_private_endpoint
      master_ipv4_cidr_block  = private_cluster_config.value.master_ipv4_cidr_block

      dynamic "master_global_access_config" {
        for_each = private_cluster_config.value.master_global_access_config != null && length(private_cluster_config.value.master_global_access_config) > 0 ? [private_cluster_config.value.master_global_access_config] : []
        content {
          enabled = master_global_access_config.value.enabled
        }
      }
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config != null && length(var.master_authorized_networks_config.cidr_blocks) > 0 ? [var.master_authorized_networks_config] : []
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  dynamic "release_channel" {
    for_each = var.release_channel != null ? [var.release_channel] : []
    content {
      channel = release_channel.value.channel
    }
  }

  dynamic "workload_identity_config" {
    for_each = var.workload_identity_config != null && try(var.workload_identity_config.workload_pool, null) != null ? [var.workload_identity_config] : []
    content {
      workload_pool = workload_identity_config.value.workload_pool
    }
  }

  addons_config {
    http_load_balancing {
      disabled = try(var.addons_config.http_load_balancing.disabled, false)
    }
    horizontal_pod_autoscaling {
      disabled = try(var.addons_config.horizontal_pod_autoscaling.disabled, false)
    }
    network_policy_config {
      disabled = try(var.addons_config.network_policy_config.disabled, true)
    }
    cloudrun_config {
      disabled           = try(var.addons_config.cloudrun_config.disabled, true)
      load_balancer_type = try(var.addons_config.cloudrun_config.load_balancer_type, null)
    }
    dns_cache_config {
      enabled = try(var.addons_config.dns_cache_config.enabled, false)
    }
    gce_persistent_disk_csi_driver_config {
      enabled = try(var.addons_config.gce_persistent_disk_csi_driver_config.enabled, true)
    }
    gcp_filestore_csi_driver_config {
      enabled = try(var.addons_config.gcp_filestore_csi_driver_config.enabled, false)
    }
    gke_backup_agent_config {
      enabled = try(var.addons_config.gke_backup_agent_config.enabled, false)
    }
    gcs_fuse_csi_driver_config {
      enabled = try(var.addons_config.gcs_fuse_csi_driver_config.enabled, false)
    }
  }

  logging_config {
    enable_components = try(var.logging_config.enable_components, ["SYSTEM_COMPONENTS", "WORKLOADS"])
  }

  dynamic "monitoring_config" {
    for_each = var.monitoring_config != null && length(var.monitoring_config) > 0 ? [var.monitoring_config] : []
    content {
      enable_components = try(monitoring_config.value.enable_components, ["SYSTEM_COMPONENTS"])
      dynamic "managed_prometheus" {
        for_each = monitoring_config.value.managed_prometheus != null ? [monitoring_config.value.managed_prometheus] : []
        content {
          enabled = try(managed_prometheus.value.enabled, false)
        }
      }
    }
  }

  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy != null && length(var.maintenance_policy) > 0 ? [var.maintenance_policy] : []
    content {
      dynamic "recurring_window" {
        for_each = maintenance_policy.value.recurring_window != null ? [maintenance_policy.value.recurring_window] : []
        content {
          start_time = recurring_window.value.start_time
          end_time   = recurring_window.value.end_time
          recurrence = recurring_window.value.recurrence
        }
      }
      dynamic "daily_maintenance_window" {
        for_each = maintenance_policy.value.daily_maintenance_window != null ? [maintenance_policy.value.daily_maintenance_window] : []
        content {
          start_time = daily_maintenance_window.value.start_time
        }
      }
    }
  }

  dynamic "network_policy" {
    for_each = var.network_policy != null && length(var.network_policy) > 0 ? [var.network_policy] : []
    content {
      enabled  = network_policy.value.enabled
      provider = network_policy.value.provider
    }
  }

  database_encryption {
    state    = var.database_encryption.state
    key_name = var.database_encryption.key_name
  }

  dynamic "binary_authorization" {
    for_each = var.binary_authorization != null && length(var.binary_authorization) > 0 ? [var.binary_authorization] : []
    content {
      evaluation_mode = binary_authorization.value.evaluation_mode
    }
  }

  dynamic "cluster_autoscaling" {
    for_each = var.cluster_autoscaling != null ? [var.cluster_autoscaling] : []
    content {
      enabled             = cluster_autoscaling.value.enabled
      autoscaling_profile = cluster_autoscaling.value.autoscaling_profile

      dynamic "resource_limits" {
        for_each = cluster_autoscaling.value.resource_limits
        content {
          resource_type = resource_limits.value.resource_type
          minimum       = resource_limits.value.minimum
          maximum       = resource_limits.value.maximum
        }
      }

      dynamic "auto_provisioning_defaults" {
        for_each = cluster_autoscaling.value.auto_provisioning_defaults != null ? [cluster_autoscaling.value.auto_provisioning_defaults] : []
        content {
          service_account = auto_provisioning_defaults.value.service_account
          oauth_scopes    = auto_provisioning_defaults.value.oauth_scopes
          dynamic "management" {
            for_each = auto_provisioning_defaults.value.management != null ? [auto_provisioning_defaults.value.management] : []
            content {
              auto_repair  = management.value.auto_repair
              auto_upgrade = management.value.auto_upgrade
            }
          }
        }
      }
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = var.master_auth.client_certificate_config.issue_client_certificate
    }
  }

  dynamic "authenticator_groups_config" {
    for_each = var.authenticator_groups_config != null ? [var.authenticator_groups_config] : []
    content {
      security_group = authenticator_groups_config.value.security_group
    }
  }

  dynamic "confidential_nodes" {
    for_each = var.confidential_nodes != null ? [var.confidential_nodes] : []
    content {
      enabled = confidential_nodes.value.enabled
    }
  }

  dynamic "cost_management_config" {
    for_each = var.cost_management_config != null ? [var.cost_management_config] : []
    content {
      enabled = cost_management_config.value.enabled
    }
  }

  dynamic "vertical_pod_autoscaling" {
    for_each = var.vertical_pod_autoscaling != null ? [var.vertical_pod_autoscaling] : []
    content {
      enabled = vertical_pod_autoscaling.value.enabled
    }
  }

  dynamic "default_snat_status" {
    for_each = var.default_snat_status != null ? [var.default_snat_status] : []
    content {
      disabled = default_snat_status.value.disabled
    }
  }

  dynamic "dns_config" {
    for_each = var.dns_config != null ? [var.dns_config] : []
    content {
      cluster_dns        = dns_config.value.cluster_dns
      cluster_dns_scope  = dns_config.value.cluster_dns_scope
      cluster_dns_domain = dns_config.value.cluster_dns_domain
    }
  }

  dynamic "gateway_api_config" {
    for_each = var.gateway_api_config != null ? [var.gateway_api_config] : []
    content {
      channel = gateway_api_config.value.channel
    }
  }

  dynamic "identity_service_config" {
    for_each = var.identity_service_config != null ? [var.identity_service_config] : []
    content {
      enabled = identity_service_config.value.enabled
    }
  }

  dynamic "control_plane_endpoints_config" {
    for_each = var.control_plane_endpoints_config != null ? [var.control_plane_endpoints_config] : []
    content {
      dynamic "dns_endpoint_config" {
        for_each = var.control_plane_endpoints_config.dns_endpoint_config != null ? [var.control_plane_endpoints_config.dns_endpoint_config] : []
        content {
          allow_external_traffic    = dns_endpoint_config.value.allow_external_traffic
        }
      }
    }
  }
}
