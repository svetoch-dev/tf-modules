# Yandex Container Registry Module

Creates a `yandex_container_registry` with optional registry IAM bindings, IP permissions, repositories, repository IAM bindings, and repository lifecycle policies.

## Usage

```hcl
module "ycr" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/ycr?ref=master"

  folder_id = "b1gxxxxxxxxxxxxxxx"
  name      = "example-registry"

  labels = {
    env = "dev"
  }

  readers = [
    "group:aje0xxxxxxxxxxxxxx",
  ]

  writers = [
    "serviceAccount:aje0yyyyyyyyyyyyyy",
  ]

  ip_permissions = {
    read  = ["10.0.0.0/8"]
    write = ["10.10.0.0/16"]
  }

  repositories = {
    app = {
      readers = [
        "group:aje0xxxxxxxxxxxxxx",
      ]
      writers = [
        "serviceAccount:aje0yyyyyyyyyyyyyy",
      ]
      lifecycle_policy = {
        rule = {
          retained_top = 10
          tag_regexp   = "^release-.*"
        }
      }
    }
  }

  timeouts = {
    create = "5m"
    read   = "5m"
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
| `folder_id` | Folder where the registry will be created. | `string` | n/a | yes |
| `name` | Name of the registry. Must be at least 3 characters. | `string` | n/a | yes |
| `labels` | A set of key/value label pairs assigned to the registry. | `map(string)` | `{}` | no |
| `timeouts` | Custom timeouts for the registry resource. | `object` | `null` | no |
| `readers` | IAM member strings that will be granted `container-registry.images.puller` on the registry. | `list(string)` | `[]` | no |
| `writers` | IAM member strings that will be granted `container-registry.images.pusher` on the registry. | `list(string)` | `[]` | no |
| `ip_permissions` | CIDR-based pull/push permissions for the registry. | `object` | `null` | no |
| `repositories` | Map of repositories to create in the registry. | `map(object)` | `null` | no |

## Outputs

This module does not currently define Terraform outputs.

## Notes

- `readers` are converted into a single `yandex_container_registry_iam_binding` with role `container-registry.images.puller` when the list is non-empty.
- `writers` are converted into a single `yandex_container_registry_iam_binding` with role `container-registry.images.pusher` when the list is non-empty.
- `ip_permissions` creates `yandex_container_registry_ip_permission` only when either the read or write CIDR list is non-empty.
- `repositories[*].name` defaults to `<registry_id>/<map_key>` when omitted.
- `repositories[*].readers` and `repositories[*].writers` create repository-level IAM bindings only when their lists are non-empty.
- `repositories[*].lifecycle_policy.name` defaults to `<repository_key>-policy` when omitted.
- `repositories[*].lifecycle_policy.rule.description` defaults to `<repository_key> lifecycle policy rule` when omitted.

## Type Details

### `timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `read` | `string` | no | Timeout for read operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |

### `ip_permissions`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `write` | `list(string)` | no | CIDRs allowed to push images. |
| `read` | `list(string)` | no | CIDRs allowed to pull images. |
| `default_timeouts` | `string` | no | Default timeout value used by the IP permission resource. |

### `repositories`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | no | Repository name suffix. When omitted, the map key is used. |
| `writers` | `list(string)` | no | IAM member strings granted `container-registry.images.pusher` on the repository. |
| `readers` | `list(string)` | no | IAM member strings granted `container-registry.images.puller` on the repository. |
| `timeouts` | `object` | no | Custom timeouts for the repository resource. |
| `lifecycle_policy` | `object` | no | Lifecycle policy for the repository. |

### `repositories{}.timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `read` | `string` | no | Timeout for read operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |

### `repositories{}.lifecycle_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | no | Lifecycle policy name. Defaults to `<repository_key>-policy`. |
| `status` | `string` | no | Lifecycle policy status. Defaults to `"active"`. |
| `description` | `string` | no | Lifecycle policy description. |
| `default_timeouts` | `string` | no | Default timeout value used by the lifecycle policy resource. |
| `rule` | `object` | no | Lifecycle policy rule configuration. |

### `repositories{}.lifecycle_policy.rule`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `expire_period` | `string` | no | Expiration period for matching images. |
| `retained_top` | `number` | no | Number of latest matching images to retain. |
| `description` | `string` | no | Rule description. Defaults to `<repository_key> lifecycle policy rule`. |
| `tag_regexp` | `string` | no | Tag regexp used to match images. |
| `untagged` | `bool` | no | Whether the rule applies to untagged images. |
