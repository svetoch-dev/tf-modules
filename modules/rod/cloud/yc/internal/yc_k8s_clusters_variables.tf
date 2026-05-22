locals {
  yc_k8s_clusters = var.env.kubernetes.enabled ? {
    tostring(var.env.short_name) = {
      node_groups = {
        runner = {
          name = "runner"

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
            network_interface = [
              {
                subnet_ids = [
                  "node-${var.env.kubernetes.node_locations[0]}"
                ]
              }
            ]
            boot_disk = {
              size = 50
              type = "network-ssd"
            }
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
          allocation_policy = {
            location = [
              {
                zone = var.env.kubernetes.node_locations[0]
              }
            ]
          }
        }
      }
    }
  } : {}
}
