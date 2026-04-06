locals {
  yc_k8s_node_subnets = [
    for subnet_name, subnet_obj in local.yc_networks_merged["main"].subnets :
    merge(
      subnet_obj,
      lookup(subnet_obj, "name", null) == null ? {
        name = subnet_name
      } : {}
    )
    if strcontains(subnet_name, "node")
  ]
  yc_k8s_master_subnets = [
    for subnet_name, subnet_obj in local.yc_networks_merged["main"].subnets :
    merge(
      subnet_obj,
      lookup(subnet_obj, "name", null) == null ? {
        name = subnet_name
      } : {}
    )
    if strcontains(subnet_name, "master")
  ]
  yc_k8s_node_groups_common = {
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
  yc_k8s_node_groups = {
    main = provider::deepmerge::mergo(
      local.yc_k8s_node_groups_common,
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
      local.yc_k8s_node_groups_common,
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
      local.yc_k8s_node_groups_common,
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
          for subnet_obj in local.yc_k8s_master_subnets :
          {
            zone      = subnet_obj.zone
            subnet_id = module.yc.subnets["main"][subnet_obj.name].id
          }
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
      node_groups = merge(
        {
          for subnet_obj in local.yc_k8s_node_subnets :
          "main-${subnet_obj.zone}" => provider::deepmerge::mergo(
            local.yc_k8s_node_groups.main,
            {
              name = "main-${split("-", subnet_obj.zone)[2]}"
              allocation_policy = {
                location = [
                  {
                    zone = subnet_obj.zone
                  }
                ]
              }
              instance_template = {
                network_interface = [
                  {
                    subnet_names = [
                      subnet_obj.name
                    ]
                  }
                ]
              }
            }
          )
        },
        {
          for subnet_obj in local.yc_k8s_node_subnets :
          "on-demand-${subnet_obj.zone}" => provider::deepmerge::mergo(
            local.yc_k8s_node_groups.main,
            {
              name = "on-demand-${split("-", subnet_obj.zone)[2]}"
              allocation_policy = {
                location = [
                  {
                    zone = subnet_obj.zone
                  }
                ]
              }
              instance_template = {
                network_interface = [
                  {
                    subnet_names = [
                      subnet_obj.name
                    ]
                  }
                ]
              }
            }
          )
        },
        var.env.short_name == "int" ? {
          "runner" = provider::deepmerge::mergo(
            local.yc_k8s_node_groups.runner,
            {
              allocation_policy = {
                location = [
                  {
                    zone = local.yc_k8s_node_subnets[0].zone
                  }
                ]
              }
              instance_template = {
                network_interface = [
                  {
                    subnet_names = [
                      local.yc_k8s_node_subnets[0].name
                    ]
                  }
                ]
              }
            }
          )
        } : {}
      )
    }
  }
}
