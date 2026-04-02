resource "yandex_kubernetes_node_group" "this" {
  cluster_id  = var.cluster_id
  name        = var.name
  description = var.description
  version     = var.k8s_version
  labels      = var.labels
  node_labels = var.node_labels
  node_taints = [
    for taint in var.node_taints :
    taint.value == null ?
    "${taint.key}=:${taint.effect}" :
    "${taint.key}=${taint.value}:${taint.effect}"
  ]
  allowed_unsafe_sysctls = var.allowed_unsafe_sysctls
  variables              = var.variables

  allocation_policy {
    dynamic "location" {
      for_each = var.allocation_policy.location

      content {
        zone      = location.value.zone
        subnet_id = location.value.subnet_id
      }
    }
  }

  dynamic "deploy_policy" {
    for_each = var.deploy_policy == null ? [] : [var.deploy_policy]

    content {
      max_expansion   = deploy_policy.value.max_expansion
      max_unavailable = deploy_policy.value.max_unavailable
    }
  }

  instance_template {
    labels                    = var.instance_template.labels
    metadata                  = var.instance_template.metadata
    name                      = var.instance_template.name
    nat                       = var.instance_template.nat
    network_acceleration_type = var.instance_template.network_acceleration_type
    platform_id               = var.instance_template.cpu_platform_id
    reserved_instance_pool_id = var.instance_template.reserved_instance_pool_id

    dynamic "boot_disk" {
      for_each = var.instance_template.boot_disk == null ? [] : [var.instance_template.boot_disk]

      content {
        size = boot_disk.value.size
        type = boot_disk.value.type
      }
    }

    dynamic "container_network" {
      for_each = var.instance_template.container_network == null ? [] : [var.instance_template.container_network]

      content {
        pod_mtu = container_network.value.pod_mtu
      }
    }

    dynamic "container_runtime" {
      for_each = var.instance_template.container_runtime == null ? [] : [var.instance_template.container_runtime]

      content {
        type = container_runtime.value.type
      }
    }

    dynamic "gpu_settings" {
      for_each = var.instance_template.gpu_settings == null ? [] : [var.instance_template.gpu_settings]

      content {
        gpu_cluster_id  = gpu_settings.value.gpu_cluster_id
        gpu_environment = gpu_settings.value.gpu_environment
      }
    }

    dynamic "network_interface" {
      for_each = var.instance_template.network_interface

      content {
        ipv4               = network_interface.value.ipv4
        ipv6               = network_interface.value.ipv6
        nat                = network_interface.value.nat
        security_group_ids = network_interface.value.security_group_ids
        subnet_ids = network_interface.value.subnet_ids != [] ? network_interface.value.subnet_ids : [
          for subnet_name in network_interface.value.subnet_names :
          data.yandex_vpc_subnet.subnets[subnet_name].id
        ]

        dynamic "ipv4_dns_records" {
          for_each = network_interface.value.ipv4_dns_records

          content {
            dns_zone_id = ipv4_dns_records.value.dns_zone_id
            fqdn        = ipv4_dns_records.value.fqdn
            ptr         = ipv4_dns_records.value.ptr
            ttl         = ipv4_dns_records.value.ttl
          }
        }

        dynamic "ipv6_dns_records" {
          for_each = network_interface.value.ipv6_dns_records

          content {
            dns_zone_id = ipv6_dns_records.value.dns_zone_id
            fqdn        = ipv6_dns_records.value.fqdn
            ptr         = ipv6_dns_records.value.ptr
            ttl         = ipv6_dns_records.value.ttl
          }
        }
      }
    }

    dynamic "placement_policy" {
      for_each = var.instance_template.placement_policy == null ? [] : [var.instance_template.placement_policy]

      content {
        placement_group_id = placement_policy.value.placement_group_id
      }
    }

    dynamic "resources" {
      for_each = var.instance_template.resources == null ? [] : [var.instance_template.resources]

      content {
        core_fraction = resources.value.core_fraction
        cores         = resources.value.cores
        gpus          = resources.value.gpus
        memory        = resources.value.memory
      }
    }

    dynamic "scheduling_policy" {
      for_each = var.instance_template.scheduling_policy == null ? [] : [var.instance_template.scheduling_policy]

      content {
        preemptible = scheduling_policy.value.preemptible
      }
    }
  }

  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy == null ? [] : [var.maintenance_policy]

    content {
      auto_repair  = maintenance_policy.value.auto_repair
      auto_upgrade = maintenance_policy.value.auto_upgrade

      dynamic "maintenance_window" {
        for_each = maintenance_policy.value.maintenance_window

        content {
          day        = maintenance_window.value.day
          duration   = maintenance_window.value.duration
          start_time = maintenance_window.value.start_time
        }
      }
    }
  }

  scale_policy {
    dynamic "auto_scale" {
      for_each = var.scale_policy.auto_scale == null ? [] : [var.scale_policy.auto_scale]

      content {
        initial = auto_scale.value.initial
        max     = auto_scale.value.max
        min     = auto_scale.value.min
      }
    }

    dynamic "fixed_scale" {
      for_each = var.scale_policy.fixed_scale == null ? [] : [var.scale_policy.fixed_scale]

      content {
        size = fixed_scale.value.size
      }
    }
  }

  dynamic "workload_identity_federation" {
    for_each = var.workload_identity_federation == null ? [] : [var.workload_identity_federation]

    content {
      enabled = workload_identity_federation.value.enabled
    }
  }
}

data "yandex_vpc_subnet" "subnets" {
  for_each = toset(
    concat(
      [
        for interface in var.instance_template.network_interface :
        interface.subnet_names
      ]...
    )
  )
  name = each.value
}
