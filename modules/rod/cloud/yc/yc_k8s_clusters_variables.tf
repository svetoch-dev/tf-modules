locals {
  yc_k8s_nodes_common = {
    allocation_policy = {
      location = [
        for subnet_name in var.env.kubernetes.node_locations :
        {
          zone = subnet_name
        }
      ]
    }
    deploy_policy = {
      max_expansion   = 2
      max_unavailable = 0
    }
    maintenance_policy = {
      auto_upgrade = true
      auto_repair  = true
      maintenance_window = [
        {
          day        = "sunday"
          duration   = "3h"
          start_time = "16:00"
        }
      ]
    }
    instance_template = {
      cpu_platform_id = "standard-v4a"
      network_interface = [
        {
          subnet_names = [
            for subnet_name, subnet_obj in local.yc_networks_merged["main"].subnets :
            subnet_name
            if strcontains(subnet_name, "node")
          ]
        }
      ]
      resources = {
        core_fraction = 100
        cores         = 4
        memory        = 16
      }
      container_runtime = {
        type = "containerd"
      }
      scheduling_policy = {
        preemptible = true
      }
      boot_disk = {
        size = 45
        type = "network-hdd"
      }
    }
    scale_policy = {
      auto_scale = {
        initial = 0
        max     = 10
        min     = 0
      }
    }
    workload_identity_federation = {
      enabled = true
    }
  }
  yc_k8s_clusters = {
    tostring(var.env.short_name) = {
      name                    = var.env.short_name
      network_id              = module.yc.vpcs["main"].id
      service_account_id      = module.yc.iam.service_accounts["k8s-master"].id
      node_service_account_id = module.yc.iam.service_accounts["k8s-nodes"].id
      pod_ipv4_range          = var.env.cloud.network.k8s_pod_cidr
      service_ipv4_range      = var.env.cloud.network.k8s_service_cidr
      workload_identity_federation = {
        enabled = true
      }
      admins = [
        "serviceAccountName:argocd"
      ]
      master = {
        public_ip = true
        master_location = [
          for subnet_name, subnet_obj in local.yc_networks_merged["main"].subnets :
          {
            zone      = subnet_obj.zone
            subnet_id = module.yc.subnets["main"][subnet_name].id
          }
          if strcontains(subnet_name, "master")
        ]
        maintenance_policy = {
          auto_upgrade = true
          maintenance_window = [
            {
              day        = "sunday"
              duration   = "3h"
              start_time = "13:00"
            }
          ]
        }
      }
      node_groups = {
        main = provider::deepmerge::mergo(
          local.yc_k8s_nodes_common,
          {
            name = "main"
            node_labels = {
              main = "true"
            }
            node_taints = [
            ]
          }
        )
        on-demand = provider::deepmerge::mergo(
          local.yc_k8s_nodes_common,
          {
            name = "on-demand"
            instance_template = {
              scheduling_policy = {
                preemptible = false
              }
            }
            node_labels = {
              on-demand = "true"
            }
            node_taints = [
              {
                key    = "on-demand"
                value  = true
                effect = "NoSchedule"
              },
            ]
          }
        )
        runner = provider::deepmerge::mergo(
          local.yc_k8s_nodes_common,
          {
            name = "runner"
            instance_template = {
              boot_disk = {
                size = 120
                type = "network-ssd"
              }
            }
            scale_policy = {
              auto_scale = {
                initial = 0
                max     = 20
                min     = 0
              }
            }
            node_labels = {
              runner = "true"
            }
            node_taints = [
              {
                key    = "runner"
                value  = true
                effect = "NoSchedule"
              },
            ]
          }
        )
      }
    }
  }
}
