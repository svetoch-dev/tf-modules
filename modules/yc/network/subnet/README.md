# Yandex Subnet Module

Creates a `yandex_vpc_subnet` resource.

## Usage

```hcl
module "subnet" {
  source = "./modules/yc/network/subnet"

  folder_id      = "b1gxxxxxxxxxxxxxxx"
  network_id     = "enpxxxxxxxxxxxxxxx"
  name           = "example-subnet"
  description    = "Application subnet"
  zone           = "ru-central1-a"
  ip_cidr_ranges = ["10.10.0.0/24"]
  route_table_id = "enprtxxxxxxxxxxxxx"

  labels = {
    env = "dev"
  }

  dhcp_options = {
    domain_name         = "internal"
    domain_name_servers = ["10.0.0.2"]
    ntp_servers         = ["10.0.0.3"]
  }

  timeouts = {
    create = "5m"
    update = "5m"
    delete = "5m"
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
| `folder_id` | The folder where the subnet will be created. | `string` | n/a | yes |
| `network_id` | The VPC network ID. | `string` | n/a | yes |
| `ip_cidr_ranges` | IPv4 CIDR blocks for the subnet. | `list(string)` | n/a | yes |
| `name` | Subnet name. | `string` | n/a | no |
| `description` | Subnet description. | `string` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the subnet. | `map(string)` | `{}` | no |
| `zone` | Subnet zone. | `string` | n/a | no |
| `dhcp_options` | Options for DHCP clients in the subnet. | `object({ domain_name = optional(string), domain_name_servers = optional(list(string)), ntp_servers = optional(list(string)) })` | `null` | no |
| `route_table_id` | Route table ID to attach to the subnet. | `string` | `null` | no |
| `timeouts` | Custom timeouts for the subnet resource. | `object({ create = optional(string), update = optional(string), delete = optional(string) })` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The subnet resource. |

## Notes

- The module exposes all currently settable attributes of `yandex_vpc_subnet`.
- `v6_cidr_blocks` is currently provider-computed and is returned through the `this` output.
