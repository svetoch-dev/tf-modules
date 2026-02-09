locals {
  gcp_networks = {
    main = {
      vpc = {
        name = "main"
      }
      subnets = {
        "vms" = {
          ip_cidr_range = var.env.cloud.network.vm_cidr
          region        = var.env.cloud.location.region
          description   = "VM subnet"
          secondary_ip_range = [
            {
              range_name    = "pods"
              ip_cidr_range = var.env.cloud.network.k8s_pod_cidr
            },
            {
              range_name    = "services"
              ip_cidr_range = var.env.cloud.network.k8s_service_cidr
            }
          ]
        }
      }
      nat_gws = {
        "nat-gw" = {
          region      = var.env.cloud.location.region
          router_name = "router"
          ip_address_names = [
            "nat-gw-ip-1"
          ]
          min_ports_per_vm               = 32
          max_ports_per_vm               = 65536
          enable_dynamic_port_allocation = true
        }
      }
      routers = {
        "router" = {
          region = var.env.cloud.location.region
        }
      }
      ip_addresses = [
        {
          name        = "nat-gw-ip-1"
          description = "ip address for nat gw ${var.env.cloud.location.region}"
        }
      ]
      firewall_rules = {
        admission-webhooks = {
          direction = "INGRESS"
          source_ranges = [
            "172.16.0.0/28" #gke control plane
          ]
          target_tags = []
          description = null
          allow = {
            tcp = {
              ports = [
              ]
            }
          }
          deny = {}
        }
      }
    }
  }
}
