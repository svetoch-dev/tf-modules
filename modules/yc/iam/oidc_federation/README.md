# Yandex IAM OIDC Federation Module

Creates a `yandex_iam_workload_identity_oidc_federation` resource.

## Usage

```hcl
module "oidc_federation" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/iam/oidc_federation?ref=master"

  name      = "github-actions"
  folder_id = "b1gxxxxxxxxxxxxxxx"
  issuer    = "https://token.actions.githubusercontent.com"
  jwks_url  = "https://token.actions.githubusercontent.com/.well-known/jwks"
  audiences = [
    "https://github.com/svetoch-dev",
    "sts.yandexcloud.net",
  ]

  description = "OIDC federation for CI workloads"
  disabled    = false

  labels = {
    env  = "prod"
    team = "platform"
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
| yandex | 0.195.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | The name of the OIDC workload identity federation. | `string` | n/a | yes |
| `issuer` | The OIDC issuer URL used to validate the incoming token. | `string` | n/a | yes |
| `jwks_url` | The URL used to fetch the OIDC provider JSON Web Key Set. | `string` | n/a | yes |
| `audiences` | Allowed audience values for incoming OIDC tokens. | `list(string)` | n/a | yes |
| `folder_id` | The ID of the folder where the federation will be created. | `string` | `null` | no |
| `description` | An optional description of this federation. | `string` | `null` | no |
| `disabled` | Whether the federation is disabled. | `bool` | `false` | no |
| `labels` | A set of key/value label pairs assigned to the federation. | `map(string)` | `{}` | no |
| `timeouts` | Custom timeouts for the OIDC federation resource. | `object({ create = optional(string), update = optional(string), delete = optional(string) })` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The OIDC workload identity federation resource being created. |

## Notes

- The module exposes the full `yandex_iam_workload_identity_oidc_federation` resource through the `this` output.
- Read-only fields such as `id`, `created_at`, and provider-computed attributes are available via `output.this`.

## Type Details

### `timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |
