/**
 * GKE PoC Module based on native Terraform resources.
 * Supports the nested abstraction structure from k8s_poc.tf
 */

resource "google_container_cluster" "primary" {
  name     = var.name
  location = var.regional ? var.region : (length(var.zones) > 0 ? var.zones[0] : null)
  project  = var.project_id

  node_locations = var.regional ? var.zones : slice(var.zones, 1, length(var.zones))

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network.network
  subnetwork = var.network.subnetwork

  min_master_version = var.version

  deletion_protection = var.deletion_protection

  release_channel {
    channel = "STABLE"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.network.ip_range_pods
    services_secondary_range_name = var.network.ip_range_services
  }

  dynamic "private_cluster_config" {
    for_each = lookup(var.network, "enable_private_nodes", true) ? [1] : []
    content {
      enable_private_nodes    = lookup(var.network, "enable_private_nodes", true)
      enable_private_endpoint = lookup(var.network, "enable_private_endpoint", false)
      master_ipv4_cidr_block  = lookup(var.network, "master_ipv4_cidr_block", "172.16.0.0/28")
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = length(lookup(var.network, "master_authorized_networks", [])) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.network.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = lookup(cidr_blocks.value, "display_name", null)
        }
      }
    }
  }

  resource_labels = var.labels

  dynamic "workload_identity_config" {
    for_each = lookup(var.security, "identity_namespace", null) == "enabled" ? [1] : []
    content {
      workload_pool = "${var.project_id}.svc.id.goog"
    }
  }

  addons_config {
    http_load_balancing {
      disabled = !lookup(var.features, "http_load_balancing", true)
    }
    horizontal_pod_autoscaling {
      disabled = !lookup(var.features, "horizontal_pod_autoscaling", true)
    }
    gcs_fuse_csi_driver_config {
      enabled = lookup(var.features, "gcs_fuse_csi_driver", false)
    }
  }

  logging_config {
    enable_components = var.logging_enabled_components
  }

  dynamic "maintenance_policy" {
    for_each = length(var.maintenance) > 0 ? [1] : []
    content {
      recurring_window {
        start_time = var.maintenance.start_time
        end_time   = var.maintenance.end_time
        recurrence = var.maintenance.recurrence
      }
    }
  }

  network_policy {
    enabled  = lookup(var.network, "network_policy", false)
    provider = lookup(var.network, "network_policy_provider", "PROVIDER_UNSPECIFIED")
  }
}

resource "google_container_node_pool" "pools" {
  for_each = var.node_pools

  name     = each.key
  location = var.regional ? var.region : (length(var.zones) > 0 ? var.zones[0] : null)
  cluster  = google_container_cluster.primary.name
  project  = var.project_id

  initial_node_count = lookup(each.value, "initial_node_count", 0)

  dynamic "autoscaling" {
    for_each = lookup(each.value, "min_count", null) != null ? [1] : []
    content {
      min_node_count = each.value.min_count
      max_node_count = each.value.max_count
    }
  }

  node_config {
    machine_type    = lookup(each.value, "machine_type", "e2-medium")
    service_account = lookup(each.value, "service_account", "default")
    oauth_scopes    = lookup(each.value, "oauth_scopes", ["https://www.googleapis.com/auth/cloud-platform"])

    tags   = lookup(each.value, "tags", [])
    labels = lookup(each.value, "labels", {})

    metadata = {
      disable-legacy-endpoints = "true"
    }

    dynamic "taint" {
      for_each = lookup(each.value, "taints", [])
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    spot         = lookup(each.value, "spot", false)
    preemptible  = lookup(each.value, "preemptible", false)
    disk_size_gb = lookup(each.value, "disk_size_gb", 100)
    disk_type    = lookup(each.value, "disk_type", "pd-standard")
    image_type   = lookup(each.value, "image_type", "COS_CONTAINERD")

    shielded_instance_config {
      enable_secure_boot          = lookup(each.value, "enable_secure_boot", false)
      enable_integrity_monitoring = lookup(each.value, "enable_integrity_monitoring", true)
    }

    # Handle GKE_METADATA node metadata for security
    workload_metadata_config {
      mode = lookup(var.security, "node_metadata", "GKE_METADATA")
    }
  }

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", true)
  }

  lifecycle {
    ignore_changes = [
      initial_node_count,
    ]
  }
}
