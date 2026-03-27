locals {
  gcp_gke_clusters = {
    tostring(var.env.short_name) = {
      name                = var.env.short_name
      enabled             = var.env.kubernetes.enabled
      deletion_protection = var.env.kubernetes.deletion_protection
      regional            = var.env.kubernetes.regional
      region              = var.env.cloud.location.region
      zones               = var.env.kubernetes.node_locations

      network = {
        network                 = module.gcp.vpcs["main"].network_name
        subnetwork              = module.gcp.subnets["main"]["vms"].name
        ip_range_pods           = module.gcp.subnets["main"]["vms"].secondary_ip_range[0].range_name
        ip_range_services       = module.gcp.subnets["main"]["vms"].secondary_ip_range[1].range_name
        network_policy          = true
        network_policy_provider = "CALICO"
        enable_private_nodes    = true
        enable_private_endpoint = false
        master_ipv4_cidr_block  = "172.16.0.0/28"
        master_authorized_networks = [
          {
            cidr_block   = "0.0.0.0/0"
            display_name = "Allow all"
          }
        ]
      }

      features = {
        http_load_balancing             = true
        horizontal_pod_autoscaling      = true
        enable_vertical_pod_autoscaling = true
        enable_shielded_nodes           = false
        gcs_fuse_csi_driver             = true
        authenticator_security_group    = var.env.kubernetes.auth_group != "" ? var.env.kubernetes.auth_group : null
      }

      security = {
        identity_namespace = "enabled"
        node_metadata      = "GKE_METADATA"
      }

      logging_enabled_components = [
        "SYSTEM_COMPONENTS",
        "APISERVER",
        "CONTROLLER_MANAGER",
        "SCHEDULER",
      ]

      maintenance = {
        start_time = "2020-02-07T06:00:00Z"
        recurrence = "FREQ=WEEKLY;BYDAY=SA"
        end_time   = "2020-02-07T18:00:00Z"
      }

      labels = {
        "env" = var.env.short_name
      }

      node_pools = {
        main = {
          name               = "main"
          machine_type       = "t2d-standard-4"
          node_locations     = join(",", var.env.kubernetes.node_locations)
          min_count          = 0
          max_count          = 10
          local_ssd_count    = 0
          disk_size_gb       = 45
          disk_type          = "pd-ssd"
          image_type         = "COS_CONTAINERD"
          auto_repair        = true
          auto_upgrade       = true
          service_account    = "k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
          preemptible        = false
          spot               = true
          initial_node_count = 0
          oauth_scopes = [
            "https://www.googleapis.com/auth/userinfo.email",
            "https://www.googleapis.com/auth/cloud-platform"
          ]
          labels = {
            main = "true"
          }
          taints = []
          tags   = []
        },
        on-demand = {
          name               = "on-demand"
          machine_type       = "t2d-standard-4"
          node_locations     = join(",", var.env.kubernetes.node_locations)
          min_count          = 0
          max_count          = 10
          local_ssd_count    = 0
          disk_size_gb       = 45
          disk_type          = "pd-ssd"
          image_type         = "COS_CONTAINERD"
          auto_repair        = true
          auto_upgrade       = true
          service_account    = "k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
          preemptible        = false
          spot               = false
          initial_node_count = 0
          oauth_scopes = [
            "https://www.googleapis.com/auth/userinfo.email",
            "https://www.googleapis.com/auth/cloud-platform"
          ]
          labels = {
            on-demand = "true"
          }
          taints = [
            {
              key    = "on-demand"
              value  = "true"
              effect = "NO_SCHEDULE"
            },
          ]
          tags = []
        }
        runner = var.env.short_name == "int" ? {
          name               = "runner"
          machine_type       = "t2d-standard-4"
          node_locations     = join(",", var.env.kubernetes.node_locations)
          min_count          = 0
          max_count          = 20
          local_ssd_count    = 0
          disk_size_gb       = 120
          disk_type          = "pd-ssd"
          image_type         = "COS_CONTAINERD"
          auto_repair        = true
          auto_upgrade       = true
          service_account    = "k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
          preemptible        = false
          spot               = true
          initial_node_count = 0
          oauth_scopes = [
            "https://www.googleapis.com/auth/userinfo.email",
            "https://www.googleapis.com/auth/cloud-platform"
          ]
          labels = {
            runner = "true"
          }
          taints = [
            {
              key    = "runner"
              value  = "true"
              effect = "NO_SCHEDULE"
            },
          ]
          tags = []
        } : null,
      }
    }
  }
}
