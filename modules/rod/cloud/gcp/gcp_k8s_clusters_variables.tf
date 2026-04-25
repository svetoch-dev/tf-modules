locals {
  gcp_k8s_clusters = {
    tostring(var.env.short_name) = {
      name                = var.env.short_name
      enabled             = var.env.kubernetes.enabled
      deletion_protection = var.env.kubernetes.deletion_protection
      location            = var.env.kubernetes.regional ? var.env.cloud.location.region : var.env.cloud.location.default_zone
      node_locations      = var.env.kubernetes.node_locations

      network    = module.gcp.vpcs["main"].network_id
      subnetwork = module.gcp.subnets["main"]["vms"].id
      ip_allocation_policy = {
        cluster_secondary_range_name  = module.gcp.subnets["main"]["vms"].secondary_ip_range[0].range_name
        services_secondary_range_name = module.gcp.subnets["main"]["vms"].secondary_ip_range[1].range_name
      }

      private_cluster_config = {
        master_ipv4_cidr_block = "172.16.0.0/28"
      }

      master_authorized_networks_config = {
        cidr_blocks = [{
          cidr_block   = "0.0.0.0/0"
          display_name = "Allow all"
        }]
      }

      addons_config = {
        gce_persistent_disk_csi_driver_config_enabled = true
        gcs_fuse_csi_driver_config_enabled            = true
      }

      network_policy = {
        enabled = true
      }

      authenticator_groups_config_security_group = var.env.kubernetes.auth_group != "" ? var.env.kubernetes.auth_group : null

      logging_config_enable_components = [
        "SYSTEM_COMPONENTS",
        "APISERVER",
        "CONTROLLER_MANAGER",
        "SCHEDULER",
      ]

      maintenance_policy = {
        recurring_window = {
          start_time = "2020-02-07T06:00:00Z"
          recurrence = "FREQ=WEEKLY;BYDAY=SA"
          end_time   = "2020-02-07T18:00:00Z"
        }
      }

      resource_labels = {
        "env" = var.env.short_name
      }

      node_pools = {
        main = {
          name = "main"
          node_config = {
            machine_type    = "t2d-standard-4"
            service_account = "k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
            disk_size_gb    = 45
            labels = {
              main = "true"
            }
            spot = true
          }
          autoscaling = {
            min_node_count = 0
            max_node_count = 10
          }
          kubelet_config = {
            cpu_cfs_quota = true
          }
          network_config = {
            pod_range = module.gcp.subnets["main"]["vms"].secondary_ip_range[0].range_name
          }
        },
        on-demand = {
          name = "on-demand"
          node_config = {
            machine_type    = "t2d-standard-4"
            service_account = "k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
            disk_size_gb    = 45
            labels = {
              on-demand = "true"
            }
            taint = [
              {
                key    = "on-demand"
                value  = "true"
                effect = "NO_SCHEDULE"
              },
            ]
          }
          kubelet_config = {
            cpu_cfs_quota = true
          }
          autoscaling = {
            min_node_count  = 0
            max_node_count  = 10
            location_policy = "BALANCED"
          }
          network_config = {
            pod_range = module.gcp.subnets["main"]["vms"].secondary_ip_range[0].range_name
          }
        }
        runner = var.env.short_name == "int" ? {
          name = "runner"
          node_config = {
            machine_type    = "t2d-standard-4"
            service_account = "k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
            disk_size_gb    = 120
            spot            = true
            labels = {
              runner = "true"
            }
            taint = [
              {
                key    = "runner"
                value  = "true"
                effect = "NO_SCHEDULE"
              },
            ]
          }
          autoscaling = {
            min_node_count = 0
            max_node_count = 20
          }
          network_config = {
            pod_range = module.gcp.subnets["main"]["vms"].secondary_ip_range[0].range_name
          }
        } : null,
      }
    }
  }
}
