# Yandex DNS Records Module

Creates a `yandex_dns_recordset` resource.

## Usage

```hcl
module "records" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/dns/records?ref=master"

  zone_id = "dnszonexxxxxxxxxxxx"
  name    = "api.example.internal."
  type    = "A"
  ttl     = 300
  data = [
    "10.0.0.10",
    "10.0.0.11",
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
| `zone_id` | The DNS zone ID where the record set will be managed. | `string` | n/a | yes |
| `name` | Record set name. | `string` | n/a | yes |
| `type` | DNS record type. | `string` | n/a | yes |
| `ttl` | TTL for the record set, in seconds. | `number` | n/a | yes |
| `data` | List of record values for the record set. | `list(string)` | n/a | yes |
| `timeouts` | Custom timeouts for the DNS record set resource. | `object` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The DNS record set resource. |

## Notes

- The module is a thin wrapper around `yandex_dns_recordset` and is intended to expose all currently settable resource attributes.
- `name` should be provided in DNS FQDN form expected by the provider. In practice this usually means a trailing dot, for example `api.example.internal.`.
- `data` should contain record payloads appropriate for the selected record `type`.

## Type Details

### `timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |
