# Yandex IP Address Module

Creates a `yandex_vpc_address` resource.

## Usage

```hcl
module "ip_address" {
  source = "./modules/yc/network/ip_address"

  folder_id    = "b1gxxxxxxxxxxxxxxx"
  name         = "example-ip-address"
  description  = "Reserved public IP"

  labels = {
    env = "dev"
  }

  deletion_protection = false

  external_ipv4_address = {
    zone_id = "ru-central1-a"
  }

  dns_record = [
    {
      dns_zone_id = "dnszonexxxxxxxxxxxx"
      fqdn        = "app.example.internal."
      ttl         = 300
    }
  ]

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
| `folder_id` | The folder where the IP address will be created. | `string` | n/a | yes |
| `external_ipv4_address` | Configuration of the reserved external IPv4 address. | <pre>object({<br>  zone_id                  = optional(string)<br>  ddos_protection_provider = optional(string)<br>  outgoing_smtp_capability = optional(string)<br>})</pre> | n/a | yes |
| `name` | IP address name. | `string` | n/a | yes |
| `description` | IP address description. | `string` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the IP address. | `map(string)` | `{}` | no |
| `deletion_protection` | Protect the IP address from accidental deletion. | `bool` | `false` | no |
| `dns_record` | DNS records to attach to the IP address. | <pre>list(object({<br>  dns_zone_id = string<br>  fqdn        = string<br>  ptr         = optional(bool)<br>  ttl         = optional(number)<br>}))</pre> | `[]` | no |
| `timeouts` | Custom timeouts for the IP address resource. | <pre>object({<br>  create = optional(string)<br>  update = optional(string)<br>  delete = optional(string)<br>})</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The reserved public IP address resource. |

## Notes

- The module exposes all currently settable attributes of `yandex_vpc_address`.
- The provider requires only one of `external_ipv4_address.ddos_protection_provider` or `external_ipv4_address.outgoing_smtp_capability`.
- The provider schema currently marks `external_ipv4_address.address` as computed, so it is returned through the `this` output rather than accepted as an input.
