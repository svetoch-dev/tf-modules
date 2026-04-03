locals {
  iam_roles = flatten(
    [
      for iam_role, iam_role_obj in var.iam_roles :
      [
        for member in iam_role_obj.members :
        {
          role   = iam_role_obj.role
          member = member
        }
      ]
    ]
  )
}

resource "yandex_kubernetes_cluster" "this" {
  name                     = var.name
  description              = var.description
  folder_id                = var.folder_id
  labels                   = var.labels
  network_id               = var.network_id
  service_account_id       = var.service_account_id == null ? module.master_sa[0].this.id : var.service_account_id
  node_service_account_id  = var.node_service_account_id == null ? module.node_sa[0].this.id : var.node_service_account_id
  release_channel          = var.release_channel
  network_policy_provider  = var.network_policy_provider
  cluster_ipv4_range       = var.pod_ipv4_range
  cluster_ipv6_range       = var.pod_ipv6_range
  service_ipv4_range       = var.service_ipv4_range
  service_ipv6_range       = var.service_ipv6_range
  node_ipv4_cidr_mask_size = var.node_ipv4_cidr_mask_size

  master {
    etcd_cluster_size  = var.master.etcd_cluster_size
    public_ip          = var.master.public_ip
    security_group_ids = var.master.security_group_ids
    version            = var.master.k8s_version

    dynamic "maintenance_policy" {
      for_each = var.master.maintenance_policy == null ? [] : [var.master.maintenance_policy]

      content {
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

    dynamic "master_location" {
      for_each = var.master.master_location

      content {
        zone      = master_location.value.zone
        subnet_id = master_location.value.subnet_id
      }
    }

    dynamic "master_logging" {
      for_each = var.master.master_logging == null ? [] : [var.master.master_logging]

      content {
        audit_enabled              = master_logging.value.audit_enabled
        cluster_autoscaler_enabled = master_logging.value.cluster_autoscaler_enabled
        enabled                    = master_logging.value.enabled
        events_enabled             = master_logging.value.events_enabled
        folder_id                  = master_logging.value.folder_id
        kube_apiserver_enabled     = master_logging.value.kube_apiserver_enabled
        log_group_id               = master_logging.value.log_group_id
      }
    }


    dynamic "regional" {
      for_each = var.master.regional == null ? [] : [var.master.regional]

      content {
        region = regional.value.region

        dynamic "location" {
          for_each = regional.value.location

          content {
            zone      = location.value.zone
            subnet_id = location.value.subnet_id
          }
        }
      }
    }

    dynamic "scale_policy" {
      for_each = var.master.scale_policy == null ? [] : [var.master.scale_policy]

      content {
        dynamic "auto_scale" {
          for_each = scale_policy.value.auto_scale == null ? [] : [scale_policy.value.auto_scale]

          content {
            min_resource_preset_id = auto_scale.value.min_resource_preset_id
          }
        }
      }
    }

    dynamic "zonal" {
      for_each = var.master.zonal == null ? [] : [var.master.zonal]

      content {
        subnet_id = zonal.value.subnet_id
        zone      = zonal.value.zone
      }
    }
  }

  dynamic "network_implementation" {
    for_each = var.network_implementation == null ? [] : [var.network_implementation]

    content {
      dynamic "cilium" {
        for_each = network_implementation.value.cilium == null ? [] : [network_implementation.value.cilium]

        content {}
      }
    }
  }
  dynamic "kms_provider" {
    for_each = var.kms_provider == null ? [] : [var.kms_provider]

    content {
      key_id = kms_provider.value.key_id
    }
  }

  dynamic "workload_identity_federation" {
    for_each = var.workload_identity_federation == null ? [] : [var.workload_identity_federation]

    content {
      enabled = workload_identity_federation.value.enabled
    }
  }
}

resource "yandex_kubernetes_cluster_iam_member" "this" {
  for_each = {
    for iam_role in local.iam_roles :
    "${iam_role.role}.${iam_role.member}" => iam_role
  }
  cluster_id = yandex_kubernetes_cluster.this.id
  role       = each.value.role
  member     = module.members[each.value.member].converted
}


module "members" {
  source = "../../iam/member"
  for_each = toset(
    flatten(
      [
        for iam_role in var.iam_roles :
        iam_role.members
      ]
    )
  )
  member = each.value
}

module "master_sa" {
  source      = "../../iam/service_account"
  count       = var.service_account_id == null ? 1 : 0
  folder_id   = var.folder_id
  name        = "k8s-master"
  description = "default service account for k8s master nodes"
  roles = [
    "k8s.clusters.agent",
    "k8s.tunnelClusters.agent",
    "vpc.publicAdmin",
    "load-balancer.admin",
    "logging.writer",
  ]
}

module "node_sa" {
  source      = "../../iam/service_account"
  count       = var.node_service_account_id == null ? 1 : 0
  folder_id   = var.folder_id
  name        = "k8s-nodes"
  description = "default service account for k8s nodes"
  roles = [
    "container-registry.images.puller"
  ]
}
