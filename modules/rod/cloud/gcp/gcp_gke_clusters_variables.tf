locals {
  gcp_gke_clusters = {
    tostring(var.env.short_name) = {
      name                = var.env.short_name
      enabled             = var.env.kubernetes.enabled
      deletion_protection = var.env.kubernetes.deletion_protection
      location            = var.env.kubernetes.regional ? var.env.cloud.location.region : var.env.kubernetes.node_locations[0]
      node_locations      = var.env.kubernetes.node_locations
      #"projects/${var.env.cloud.id}/regions/${var.env.cloud.region}/subnetworks/${module.gcp.subnets["main"]["vms"]}"
      network                 = "projects/${var.env.cloud.id}/global/networks/${module.gcp.vpcs["main"]}"
      subnetwork              = module.gcp.subnets["main"]["vms"].self_link
      ip_range_pods           = module.gcp.subnets["main"]["vms"].secondary_ip_range[0].range_name
      ip_range_services       = module.gcp.subnets["main"]["vms"].secondary_ip_range[1].range_name
      network_policy          = {
        enabled = true
      }
      private_cluster_config = {
        master_ipv4_cidr_block  = "172.16.0.0/28"
      }

      master_authorized_networks_config = {
        cidr_blocks = [{
          cidr_block   = "0.0.0.0/0"
          display_name = "Allow all"
        }]
      }

      addons_config = {
        http_load_balancing        = {
          disabled = false
          }
        horizontal_pod_autoscaling = {
          disabled = false
          }
        gcs_fuse_csi_driver        = {
          enabled = true
          }
        }

      authenticator_security_group = {
        security_group = var.env.kubernetes.auth_group != "" ? var.env.kubernetes.auth_group : null
      }
      
      vertical_pod_autoscaling = {
        enabled = true
      }
      enable_shielded_nodes = false

      security = {
        identity_namespace = "enabled"
        node_metadata      = "GKE_METADATA"
      }

      logging_config = {
        enable_components = [
          "SYSTEM_COMPONENTS",
          "APISERVER",
          "CONTROLLER_MANAGER",
          "SCHEDULER",
        ]
      }

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
          name               = "main"
          node_locations     = var.env.kubernetes.node_locations
          node_config        = {
            machine_type       = "t2d-standard-4"
            service_account    = "k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
            oauth_scopes = [
              "https://www.googleapis.com/auth/userinfo.email",
              "https://www.googleapis.com/auth/cloud-platform"
            ]
            disk_type    = "pd-ssd"
            disk_size_gb = 45
            image_type   = "COS_CONTAINERD"
            labels = {
              main = "true"
            }
            spot         = true
          }
          autoscaling = {
            min_node_count          = 0
            max_node_count          = 10
          }
        },
        on-demand = {
          name               = "on-demand"
          node_locations     = var.env.kubernetes.node_locations
          node_config = {
            machine_type       = "t2d-standard-4"
            service_account    = "k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
            oauth_scopes = [
              "https://www.googleapis.com/auth/userinfo.email",
              "https://www.googleapis.com/auth/cloud-platform"
            ]
            disk_size_gb       = 45
            disk_type          = "pd-ssd"
            image_type         = "COS_CONTAINERD"
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
          autoscaling = {
            min_node_count          = 0
            max_node_count          = 10
          }
        }
        runner = var.env.short_name == "int" ? {
          name               = "runner"
          node_locations     = var.env.kubernetes.node_locations
          node_config        = {
            machine_type       = "t2d-standard-4"
            service_account    = "k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
            oauth_scopes = [
              "https://www.googleapis.com/auth/userinfo.email",
              "https://www.googleapis.com/auth/cloud-platform"
            ]
            disk_size_gb       = 120
            disk_type          = "pd-ssd"
            image_type         = "COS_CONTAINERD"
            spot               = true
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
            min_node_count          = 0
            max_node_count          = 20
          }
          
        } : null,
      }
    }
  }
}
