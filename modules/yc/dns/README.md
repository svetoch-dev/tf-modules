# Yandex DNS Module

Creates a DNS zone with zero or more DNS record sets.

## Usage

```hcl
module "dns" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/dns?ref=master"

  folder_id = "b1gxxxxxxxxxxxxxxx"
  name      = "example-zone"
  zone      = "example.internal."

  description = "Private DNS zone for internal services"

  labels = {
    env = "dev"
  }

  public = false
  private_networks = [
    "enp4examplevpcid",
  ]

  editors = [
    "group:aje0xxxxxxxxxxxxxx",
  ]

  records = [
    {
      name        = "api.example.internal."
      type        = "A"
      description = "Internal API endpoint"
      ttl         = 300
      data = [
        "10.0.0.10",
        "10.0.0.11",
      ]
    },
    {
      name = "www.example.internal."
      type = "CNAME"
      ttl  = 300
      data = [
        "api.example.internal.",
      ]
    },
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
| `folder_id` | The folder where the DNS zone will be created. | `string` | n/a | yes |
| `name` | DNS zone name. | `string` | n/a | yes |
| `zone` | DNS zone domain, typically ending with a trailing dot. | `string` | n/a | yes |
| `description` | DNS zone description. | `string` | `""` | no |
| `labels` | A set of key/value label pairs assigned to the DNS zone. | `map(string)` | `{}` | no |
| `public` | Whether the DNS zone should be publicly visible. | `bool` | `true` | no |
| `private_networks` | VPC network IDs attached to the DNS zone when using private visibility. | `list(string)` | `[]` | no |
| `deletion_protection` | Protect the DNS zone from accidental deletion. | `bool` | `false` | no |
| `admins` | IAM member strings that should receive the `dns.admin` role. Must use Yandex Cloud IAM member format such as `serviceAccount:<id>`, `userAccount:<login>`, `group:<id>` etc. | `list(string)` | `[]` | no |
| `viewers` | IAM member strings that should receive the `dns.viewer` role. Must use Yandex Cloud IAM member format such as `serviceAccount:<id>`, `userAccount:<login>`, `group:<id>` etc. | `list(string)` | `[]` | no |
| `editors` | IAM member strings that should receive the `dns.editor` role. Must use Yandex Cloud IAM member format such as `serviceAccount:<id>`, `userAccount:<login>`, `group:<id>` etc. | `list(string)` | `[]` | no |
| `timeouts` | Custom timeouts for the DNS zone resource. | `object` | `null` | no |
| `records` | List of DNS record sets to create in the zone. | `list(object)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `zone` | The DNS zone resource. |
| `records` | The DNS record set resources in input order. |

## Notes

- This module composes the `zone` and `record` submodules and forwards the created DNS zone ID automatically to each record set.
- `admins`, `editors`, and `viewers` are converted into `yandex_dns_zone_iam_binding` resources with roles `dns.admin`, `dns.editor`, and `dns.viewer` respectively.
- `zone` should be provided in FQDN form. In practice this usually means a trailing dot, for example `example.internal.`.
- `records[*].data` should contain record payloads appropriate for the selected record `type`.

## Type Details

### `records`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | yes | Record set name. |
| `type` | `string` | yes | DNS record type. |
| `description` | `string` | no | DNS record set description. |
| `ttl` | `number` | no | TTL for the record set, in seconds. Defaults to `300`. |
| `data` | `list(string)` | yes | List of record values for the record set. |
| `timeouts` | `object` | no | Custom timeouts for the record set resource. |

### `records{}.timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |

### `timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |
