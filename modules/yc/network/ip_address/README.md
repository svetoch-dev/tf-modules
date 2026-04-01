# Yandex IP Address Module

Creates a `yandex_vpc_address` resource.

## Usage

```hcl
module "ip_address" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/network/ip_address?ref=master"

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
| yandex | 0.195.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `folder_id` | The folder where the IP address will be created. | `string` | n/a | yes |
| `external_ipv4_address` | Configuration of the reserved external IPv4 address. | `object` | n/a | yes |
| `name` | IP address name. | `string` | n/a | yes |
| `description` | IP address description. | `string` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the IP address. | `map(string)` | `{}` | no |
| `deletion_protection` | Protect the IP address from accidental deletion. | `bool` | `false` | no |
| `dns_record` | DNS records to attach to the IP address. | `list(object)` | `[]` | no |
| `timeouts` | Custom timeouts for the IP address resource. | `object` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The reserved public IP address resource. |

## Notes

- The module exposes all currently settable attributes of `yandex_vpc_address`.
- The provider requires only one of `external_ipv4_address.ddos_protection_provider` or `external_ipv4_address.outgoing_smtp_capability`.
- The provider schema currently marks `external_ipv4_address.address` as computed, so it is returned through the `this` output rather than accepted as an input.

## Type Details

### `external_ipv4_address`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `zone_id` | `string` | no | Availability zone for the reserved external IPv4 address. |
| `ddos_protection_provider` | `string` | no | DDoS protection provider. |
| `outgoing_smtp_capability` | `string` | no | Outgoing SMTP capability setting. |

### `dns_record[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `dns_zone_id` | `string` | yes | DNS zone ID where the record should be created. |
| `fqdn` | `string` | yes | FQDN for the DNS record. |
| `ptr` | `bool` | no | Whether to create a PTR record. |
| `ttl` | `number` | no | TTL for the DNS record. |

### `timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |
