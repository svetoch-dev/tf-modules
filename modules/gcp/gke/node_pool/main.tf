resource "google_container_node_pool" "node_pool" {
  project           = var.project_id
  cluster           = var.cluster
  location          = var.location
  name              = var.name
  name_prefix       = var.name_prefix
  node_locations    = var.node_locations
  node_count        = var.node_count
  max_pods_per_node = var.max_pods_per_node

  dynamic "autoscaling" {
    for_each = var.autoscaling != null ? [var.autoscaling] : []
    content {
      min_node_count       = autoscaling.value.min_node_count
      max_node_count       = autoscaling.value.max_node_count
      total_min_node_count = autoscaling.value.total_min_node_count
      total_max_node_count = autoscaling.value.total_max_node_count
      location_policy      = autoscaling.value.location_policy
    }
  }

  management {
    auto_repair  = var.management.auto_repair
    auto_upgrade = var.management.auto_upgrade
  }

  node_config {
    machine_type                = var.node_config.machine_type
    service_account             = var.node_config.service_account
    oauth_scopes                = var.node_config.oauth_scopes
    disk_size_gb                = var.node_config.disk_size_gb
    disk_type                   = var.node_config.disk_type
    image_type                  = var.node_config.image_type
    labels                      = var.node_config.labels
    metadata                    = var.node_config.metadata
    tags                        = var.node_config.tags
    preemptible                 = var.node_config.preemptible
    spot                        = var.node_config.spot
    local_ssd_count             = var.node_config.local_ssd_count
    enable_confidential_storage = var.node_config.enable_confidential_storage
    flex_start                  = var.node_config.flex_start
    logging_variant             = var.node_config.logging_variant
    resource_manager_tags       = var.node_config.resource_manager_tags
    storage_pools               = var.node_config.storage_pools

    dynamic "taint" {
      for_each = var.node_config.taint
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    dynamic "workload_metadata_config" {
      for_each = var.node_config.workload_metadata_config != null ? [var.node_config.workload_metadata_config] : []
      content {
        mode = workload_metadata_config.value.mode
      }
    }

    dynamic "shielded_instance_config" {
      for_each = var.node_config.shielded_instance_config != null ? [var.node_config.shielded_instance_config] : []
      content {
        enable_secure_boot          = shielded_instance_config.value.enable_secure_boot
        enable_integrity_monitoring = shielded_instance_config.value.enable_integrity_monitoring
      }
    }

    dynamic "kubelet_config" {
      for_each = var.node_config.kubelet_config != null ? [var.node_config.kubelet_config] : []
      content {
        allowed_unsafe_sysctls                 = kubelet_config.value.allowed_unsafe_sysctls
        container_log_max_files                = kubelet_config.value.container_log_max_files
        image_gc_high_threshold_percent        = kubelet_config.value.image_gc_high_threshold_percent
        image_gc_low_threshold_percent         = kubelet_config.value.image_gc_low_threshold_percent
        insecure_kubelet_readonly_port_enabled = kubelet_config.value.insecure_kubelet_readonly_port_enabled
        cpu_cfs_quota                          = kubelet_config.value.cpu_cfs_quota
        pod_pids_limit                         = kubelet_config.value.pod_pids_limit
      }
    }

    dynamic "linux_node_config" {
      for_each = var.node_config.linux_node_config != null ? [var.node_config.linux_node_config] : []
      content {
        sysctls     = linux_node_config.value.sysctls
        cgroup_mode = linux_node_config.value.cgroup_mode
      }
    }

    dynamic "gvnic" {
      for_each = var.node_config.gvnic != null ? [var.node_config.gvnic] : []
      content {
        enabled = gvnic.value.enabled
      }
    }

    dynamic "reservation_affinity" {
      for_each = var.node_config.reservation_affinity != null ? [var.node_config.reservation_affinity] : []
      content {
        consume_reservation_type = reservation_affinity.value.consume_reservation_type
        key                      = reservation_affinity.value.key
        values                   = reservation_affinity.value.values
      }
    }
  }

  dynamic "upgrade_settings" {
    for_each = var.upgrade_settings != null ? [var.upgrade_settings] : []
    content {
      max_surge       = upgrade_settings.value.max_surge
      max_unavailable = upgrade_settings.value.max_unavailable
      strategy        = upgrade_settings.value.strategy
    }
  }

  dynamic "placement_policy" {
    for_each = var.placement_policy != null ? [var.placement_policy] : []
    content {
      type = placement_policy.value.type
    }
  }

  dynamic "queued_provisioning" {
    for_each = var.queued_provisioning != null ? [var.queued_provisioning] : []
    content {
      enabled = queued_provisioning.value.enabled
    }
  }

  dynamic "network_config" {
    for_each = var.network_config != null ? [var.network_config] : []
    content {
      create_pod_range     = network_config.value.create_pod_range
      pod_range            = network_config.value.pod_range
      pod_ipv4_cidr_block  = network_config.value.pod_ipv4_cidr_block
      enable_private_nodes = network_config.value.enable_private_nodes
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create)
      delete = try(timeouts.value.delete)
      update = try(timeouts.value.update)
    }
  }
}
