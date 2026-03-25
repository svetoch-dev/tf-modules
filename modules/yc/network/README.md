# Yandex Network Module

Creates a VPC network and its related networking resources in Yandex Cloud.

This composite module orchestrates:
- a VPC network
- NAT gateways
- route tables
- subnets
- reserved public IP addresses
- security groups derived from `firewall_rules`

## Usage

```hcl
module "network" {
  source = "./modules/yc/network"

  vpc = {
    name        = "example-network"
    folder_id   = "b1gxxxxxxxxxxxxxxx"
    description = "Shared network for application workloads"
    labels = {
      env = "dev"
    }
  }

  nat_gws = {
    main = {
      name = "example-nat"
    }
  }

  subnets = {
    app-a = {
      ip_cidr_range = "10.10.0.0/24"
      zone          = "ru-central1-a"
      labels = {
        tier = "app"
      }
      static_routes = []
    }
  }

  ip_addresses = {
    public = {
      name = "example-ip"
      external_ipv4_address = {
        zone_id = "ru-central1-a"
      }
    }
  }

  firewall_rules = {
    allow-https = {
      direction     = "INGRESS"
      source_ranges = ["0.0.0.0/0"]
      allow = {
        tcp = {
          ports = ["443"]
        }
      }
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| yandex | 0.189.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vpc` | VPC description. | <pre>object({<br>  name        = string<br>  folder_id   = string<br>  description = optional(string, null)<br>  labels      = optional(map(string), {})<br>  timeouts = optional(object({<br>    create = optional(string)<br>    update = optional(string)<br>    delete = optional(string)<br>  }))<br>})</pre> | n/a | yes |
| `subnets` | Subnets that should be created. | <pre>map(object({<br>  ip_cidr_range = string<br>  zone          = string<br>  name          = optional(string)<br>  description   = optional(string, null)<br>  labels        = optional(map(string), {})<br>  dhcp_options = optional(object({<br>    domain_name         = optional(string)<br>    domain_name_servers = optional(list(string))<br>    ntp_servers         = optional(list(string))<br>  }))<br>  timeouts = optional(object({<br>    create = optional(string)<br>    update = optional(string)<br>    delete = optional(string)<br>  }))<br>  static_routes = optional(list(object({<br>    destination_prefix = string<br>    next_hop_address   = string<br>  })), [])<br>}))</pre> | n/a | yes |
| `nat_gws` | Map of NAT gateways to create. | <pre>map(object({<br>  name                        = optional(string)<br>  description                 = optional(string, null)<br>  labels                      = optional(map(string), {})<br>  timeouts = optional(object({<br>    create = optional(string)<br>    update = optional(string)<br>    delete = optional(string)<br>  }))<br>  subnetwork_ip_ranges_to_nat = optional(string, "ALL_SUBNETWORKS")<br>  subnetworks                 = optional(list(string), [])<br>}))</pre> | `{}` | no |
| `ip_addresses` | List of public IP addresses to reserve. | <pre>map(object({<br>  name                = optional(string)<br>  description         = optional(string, null)<br>  labels              = optional(map(string), {})<br>  deletion_protection = optional(bool, false)<br>  dns_record = optional(list(object({<br>    dns_zone_id = string<br>    fqdn        = string<br>    ptr         = optional(bool)<br>    ttl         = optional(number)<br>  })), [])<br>  external_ipv4_address = object({<br>    zone_id                  = optional(string)<br>    ddos_protection_provider = optional(string)<br>    outgoing_smtp_capability = optional(string)<br>  })<br>  timeouts = optional(object({<br>    create = optional(string)<br>    update = optional(string)<br>    delete = optional(string)<br>  }))<br>}))</pre> | `{}` | no |
| `firewall_rules` | Firewall rules. | <pre>map(object({<br>  direction     = string<br>  name          = optional(string)<br>  source_ranges = optional(list(string), [])<br>  description   = optional(string, null)<br>  allow = optional(map(object({<br>    ports = optional(list(string), [])<br>  })), {})<br>}))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vpc` | The created VPC network resource. |
| `subnets` | Map of created subnet resources. |
| `nat_gws` | Map of created NAT gateway resources. |
| `ip_addresses` | Map of reserved public IP address resources. |
| `firewall_rules` | Map of created security group resources derived from `firewall_rules`. |
| `route_tables` | Map of created route table resources. |

## Notes

- The module creates one route table per subnet and attaches it to that subnet.
- If a subnet is associated with a NAT gateway, the module injects a default route for `0.0.0.0/0` into the generated route table.
- `firewall_rules` are implemented as `yandex_vpc_security_group` resources under the hood.
