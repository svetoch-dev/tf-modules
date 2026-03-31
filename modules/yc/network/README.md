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
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/network?ref=master"

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
| `vpc` | VPC description. | `object` | n/a | yes |
| `subnets` | Subnets that should be created. | `map(object)` | n/a | yes |
| `nat_gws` | Map of NAT gateways to create. | `map(object)` | `{}` | no |
| `ip_addresses` | List of public IP addresses to reserve. | `map(object)` | `{}` | no |
| `firewall_rules` | Firewall rules. | `map(object)` | `{}` | no |

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

## Type Details

### `vpc`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | yes | VPC network name. |
| `folder_id` | `string` | yes | Folder where the VPC network will be created. |
| `description` | `string` | no | VPC description. |
| `labels` | `map(string)` | no | Labels assigned to the VPC. |
| `timeouts` | `object` | no | Custom timeouts for the VPC resource. |

### `vpc.timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |

### `subnets[KEY]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `ip_cidr_range` | `string` | yes | Primary IPv4 CIDR for the subnet. |
| `zone` | `string` | yes | Availability zone for the subnet. |
| `name` | `string` | no | Subnet name override. |
| `description` | `string` | no | Subnet description. |
| `labels` | `map(string)` | no | Labels assigned to the subnet. |
| `dhcp_options` | `object` | no | DHCP options for the subnet. |
| `timeouts` | `object` | no | Custom timeouts for the subnet resource. |
| `static_routes` | `list(object)` | no | Extra static routes for the generated route table. |

### `subnets[KEY].dhcp_options`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `domain_name` | `string` | no | DHCP domain name. |
| `domain_name_servers` | `list(string)` | no | DHCP DNS server IPs. |
| `ntp_servers` | `list(string)` | no | DHCP NTP server IPs. |

### `subnets[KEY].timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |

### `subnets[KEY].static_routes[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `destination_prefix` | `string` | yes | Route prefix in CIDR notation. |
| `next_hop_address` | `string` | yes | Next-hop IP address. |

### `nat_gws[KEY]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | no | NAT gateway name override. |
| `description` | `string` | no | NAT gateway description. |
| `labels` | `map(string)` | no | Labels assigned to the NAT gateway. |
| `timeouts` | `object` | no | Custom timeouts for the NAT gateway resource. |
| `subnetwork_ip_ranges_to_nat` | `string` | no | NAT gateway subnet selection mode. |
| `subnetworks` | `list(string)` | no | Subnet keys associated with this NAT gateway. |

### `nat_gws[KEY].timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |

### `ip_addresses[KEY]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | no | Reserved IP name. |
| `description` | `string` | no | Reserved IP description. |
| `labels` | `map(string)` | no | Labels assigned to the IP address. |
| `deletion_protection` | `bool` | no | Protect the address from deletion. |
| `dns_record` | `list(object)` | no | DNS records associated with the address. |
| `external_ipv4_address` | `object` | yes | External IPv4 address configuration. |
| `timeouts` | `object` | no | Custom timeouts for the IP address resource. |

### `ip_addresses[KEY].dns_record[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `dns_zone_id` | `string` | yes | DNS zone ID for the record. |
| `fqdn` | `string` | yes | Record FQDN. |
| `ptr` | `bool` | no | Whether to create a PTR record. |
| `ttl` | `number` | no | DNS TTL. |

### `ip_addresses[KEY].external_ipv4_address`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `zone_id` | `string` | no | Availability zone for the IP address. |
| `ddos_protection_provider` | `string` | no | DDoS protection provider. |
| `outgoing_smtp_capability` | `string` | no | Outgoing SMTP capability setting. |

### `ip_addresses[KEY].timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |

### `firewall_rules[KEY]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `direction` | `string` | yes | Rule direction, `INGRESS` or `EGRESS`. |
| `name` | `string` | no | Security group name override. |
| `source_ranges` | `list(string)` | no | Source CIDR ranges for generated rules. |
| `description` | `string` | no | Security group description. |
| `allow` | `map(object)` | no | Allowed protocols and their ports. |

### `firewall_rules[KEY].allow[PROTOCOL]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `ports` | `list(string)` | no | Ports to allow for the given protocol. |
