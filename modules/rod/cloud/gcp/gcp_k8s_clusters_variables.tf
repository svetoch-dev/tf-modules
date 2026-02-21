locals {
  gcp_k8s_cluster_nodes = {
    tostring(var.env.short_name) = {
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
        #All k8s permissions for nodes
        #are set on serviceaccount level
        #not by using oauth scopes. This
        #scopes are default ones
        oauth_scopes = [
          "https://www.googleapis.com/auth/userinfo.email",
          "https://www.googleapis.com/auth/cloud-platform"
        ]
        labels = {
          main = "true"
        }
        taints = [
        ]
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
        #All k8s permissions for nodes
        #are set on serviceaccount level
        #not by using oauth scopes. This
        #scopes are default ones
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
            value  = true
            effect = "NO_SCHEDULE"
          },
        ]
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
        #All k8s permissions for nodes
        #are set on serviceaccount level
        #not by using oauth scopes. This
        #scopes are default ones
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
            value  = true
            effect = "NO_SCHEDULE"
          },
        ]
      } : null,
    }
  }
  gcp_k8s_clusters = {
    tostring(var.env.short_name) = {
      name                = var.env.short_name
      enabled             = var.env.kubernetes.enabled
      deletion_protection = var.env.kubernetes.deletion_protection
      regional            = var.env.kubernetes.regional
      region              = var.env.cloud.location.region

      subnetwork              = module.gcp["this"].subnets["main"]["vms"].name
      network                 = module.gcp["this"].vpcs["main"].network_name
      network_policy          = true
      network_policy_provider = "CALICO"
      ip_range_pods           = module.gcp["this"].subnets["main"]["vms"].secondary_ip_range[0].range_name
      ip_range_services       = module.gcp["this"].subnets["main"]["vms"].secondary_ip_range[1].range_name

      http_load_balancing             = true
      horizontal_pod_autoscaling      = true
      create_service_account          = false
      enable_vertical_pod_autoscaling = true
      enable_shielded_nodes           = false
      gcs_fuse_csi_driver             = true
      remove_default_node_pool        = true
      authenticator_security_group    = var.env.kubernetes.auth_group != "" ? var.env.kubernetes.auth_group : null
      identity_namespace              = "enabled"
      node_metadata                   = "GKE_METADATA"
      logging_enabled_components = [
        "SYSTEM_COMPONENTS",
        "APISERVER",
        "CONTROLLER_MANAGER",
        "SCHEDULER",
      ]

      enable_private_nodes    = true
      enable_private_endpoint = false
      master_ipv4_cidr_block  = "172.16.0.0/28"

      resource_usage_export_dataset_id   = ""
      enable_network_egress_export       = false
      enable_resource_consumption_export = false

      maintenance_start_time = "2020-02-07T06:00:00Z"
      maintenance_recurrence = "FREQ=WEEKLY;BYDAY=SA"
      maintenance_end_time   = "2020-02-07T18:00:00Z"

      cluster_resource_labels = {
        "env" = var.env.short_name
      }
      master_authorized_networks = [
        {
          cidr_block   = "0.0.0.0/0"
          display_name = "Allow all"
        }
      ]

      master_global_access_enabled = false # We use public endpoint for master access so setting false to ignore

      node_pools = [
        for node_pool in values(local.gcp_k8s_cluster_nodes_merged[var.env.short_name]) :
        {
          name               = node_pool.name
          machine_type       = node_pool.machine_type
          node_locations     = node_pool.node_locations
          min_count          = node_pool.min_count
          max_count          = node_pool.max_count
          local_ssd_count    = node_pool.local_ssd_count
          disk_size_gb       = node_pool.disk_size_gb
          disk_type          = node_pool.disk_type
          image_type         = node_pool.image_type
          auto_repair        = node_pool.auto_repair
          auto_upgrade       = node_pool.auto_upgrade
          service_account    = node_pool.service_account
          preemptible        = node_pool.preemptible
          spot               = node_pool.spot
          initial_node_count = node_pool.initial_node_count
        }
        if node_pool != null
      ]

      node_pools_oauth_scopes = merge(
        {
          all = []
        },
        {
          for node_name, node_obj in local.gcp_k8s_cluster_nodes_merged[var.env.short_name] :
          node_name => node_obj.oauth_scopes
          if node_obj != null
        }
      )


      node_pools_labels = merge(
        {
          all = {}

          #Ugly hack in order to remove the default values
          default_values = {
            cluster_name = false
            node_pool    = false
          }
        },
        {
          for node_name, node_obj in local.gcp_k8s_cluster_nodes_merged[var.env.short_name] :
          node_name => node_obj.labels
          if node_obj != null
        }
      )

      node_pools_metadata = {
        all = {}

        #Ugly hack in order to remove the default values
        default_values = {
          cluster_name = false
          node_pool    = false
        }
      }

      node_pools_taints = merge(
        {
          all = []
        },
        {
          for node_name, node_obj in local.gcp_k8s_cluster_nodes_merged[var.env.short_name] :
          node_name => node_obj.taints
          if node_obj != null
        }
      )


      node_pools_tags = {
        all = []
        #Ugly hack in order to remove the default values
        default_values = [
          false,
          false,
          false
        ]
      }
    }
  }
}
