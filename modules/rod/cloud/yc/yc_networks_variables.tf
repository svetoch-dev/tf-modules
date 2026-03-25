locals {
  yc_networks = {
    main = {
      vpc = {
        name = "main"
      }
      subnets = {
        "vms" = {
          ip_cidr_range = var.env.cloud.network.vm_cidr
          zone          = var.env.cloud.location.default_zone
          description   = "VM subnet"
        }
      }
      nat_gws = {
        "nat-gw" = {
          name = "main"
        }
      }
      firewall_rules = {
        admission-webhooks = {
          direction = "INGRESS"
          source_ranges = [
            "172.16.0.0/28" #yks control plane
          ]
          target_tags = []
          description = null
          allow = {
            tcp = {
              ports = [
                "8080", #konghq
                "9443", #rabbitmq operator
              ]
            }
          }
          deny = {}
        }
      }
    }
  }
}
