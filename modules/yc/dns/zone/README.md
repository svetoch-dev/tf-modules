# Yandex DNS Zone Module

Creates a `yandex_dns_zone` resource.

## Usage

```hcl
module "zone" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/dns/zone?ref=master"

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

  iam_roles = [
    {
      role = "dns.editor"
      members = [
        "group:aje0xxxxxxxxxxxxxx",
      ]
    }
  ]

  deletion_protection = false

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
| `iam_roles` | IAM roles to grant for the DNS zone. Members must use standard Yandex Cloud IAM member formats accepted by the provider. | `list(object)` | `[]` | no |
| `timeouts` | Custom timeouts for the DNS zone resource. | `object` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The DNS zone resource. |

## Notes

- The module is a thin wrapper around `yandex_dns_zone` and is intended to expose all currently settable resource attributes.
- `iam_roles` are converted into `yandex_dns_zone_iam_binding` resources and are applied with the member strings provided to the module.
- `zone` should be provided in FQDN form. In practice this usually means a trailing dot, for example `example.internal.`.
- Use `private_networks` to associate the zone with one or more VPC networks for private resolution.

## Type Details

### `iam_roles[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `role` | `string` | yes | IAM role to grant. |
| `members` | `list(string)` | yes | Members that should receive the role. Must use standard Yandex Cloud IAM member formats accepted by the provider. |

### `timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |
