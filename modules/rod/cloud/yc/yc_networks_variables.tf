locals {
  zone_suffixes = ["d", "b", "a", "e", "m"]
  #Split var.env.cloud.network.vm_cidr subnet into multiple
  #subnets based on number of var.env.kubernetes.node_locations
  cidr_subnets = lookup(
    {
      "1" = [var.env.cloud.network.vm_cidr]
      "2" = cidrsubnets(var.env.cloud.network.vm_cidr, [1, 1, ]...)
      "3" = cidrsubnets(var.env.cloud.network.vm_cidr, [2, 2, 2]...)
      "4" = cidrsubnets(var.env.cloud.network.vm_cidr, [2, 2, 2, 2]...)
    },
    tostring(length(var.env.kubernetes.node_locations))
  )


  yc_networks = {
    main = {
      vpc = {
        name = "main"
      }
      subnets = merge(
        var.env.kubernetes.regional == true ? {
          "master-${var.env.cloud.location.region}-d" = {
            ip_cidr_range = "172.16.0.0/28"
            zone          = "${var.env.cloud.location.region}-d"
            description   = "Subnet for k8s master in zone d"
          },
          "master-${var.env.cloud.location.region}-b" = {
            ip_cidr_range = "172.16.0.16/28"
            zone          = "${var.env.cloud.location.region}-b"
            description   = "Subnet for k8s master in zone b"
          },
          "master-${var.env.cloud.location.region}-a" = {
            ip_cidr_range = "172.16.0.32/28"
            zone          = "${var.env.cloud.location.region}-a"
            description   = "Subnet for k8s master in zone a"
          }
          } : {
          "master-${var.env.cloud.location.region}-d" = {
            ip_cidr_range = "172.16.0.64/28"
            zone          = "${var.env.cloud.location.region}-d"
            description   = "Subnet for k8s master in zone d"
          }
        },
        {
          for index, location in var.env.kubernetes.node_locations :
          "node-${location}" => {
            ip_cidr_range = local.cidr_subnets[index]
            zone          = location
            description   = "Subnet for k8s nodes in ${location}"
          }
        }
      )
      nat_gws = {
        "nat-gw" = {
          name = "main"
        }
      }
      firewall_rules = {}
    }
  }
}
