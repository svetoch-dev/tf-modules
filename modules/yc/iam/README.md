# Yandex IAM Module

Creates Yandex Cloud folder IAM bindings and service accounts from map-based configuration.

## Usage

```hcl
module "iam" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/iam?ref=master"

  folder_id = "b1gxxxxxxxxxxxxxxx"

  service_accounts = {
    ci-runner = {
      description = "Service account for CI jobs"
      roles = [
        "editor",
        "storage.admin",
      ]
      sa_iam_bindings = {
        "iam.serviceAccounts.user" = [
          "userAccount:user@yandex-team.ru",
        ]
      }
      generate_key = true
    }
  }

  roles = {
    viewers = {
      role = "viewer"
      members = [
        "userAccount:user@yandex-team.ru",
        "group:aje0xxxxxxxxxxxxxx",
      ]
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
| `folder_id` | Yandex Cloud folder ID where IAM resources will be managed. | `string` | n/a | yes |
| `service_accounts` | Map of service account definitions keyed by service account name. | `map(object(...))` | `{}` | no |
| `roles` | Map of folder IAM role assignments keyed by arbitrary binding name. | `map(object(...))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `service_accounts` | Map of created service accounts keyed by service account name. Each value matches the `service_account` submodule `this` output and includes a `key` field. |

## Notes

- `service_accounts` are created before top-level `roles`, so role bindings can safely reference service accounts created by the same module call.
- Each entry in `roles` creates a nested `modules/yc/iam/role` module.
- Each entry in `service_accounts` creates a nested `modules/yc/iam/service_account` module.
- Service account IAM member strings and folder IAM member strings must use Yandex Cloud IAM member format such as `serviceAccount:<id>`, `userAccount:<login>`, or `group:<id>`.
- When `generate_key = true`, the generated private key is exposed through the `service_accounts` output and should be handled as sensitive infrastructure data.

## Type Details

### `service_accounts`

Map key: service account name.

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `description` | `string` | yes | Description for the service account being created. |
| `roles` | `list(string)` | no | Folder-level IAM roles to grant to the created service account. Default is `[]`. |
| `sa_iam_bindings` | `map(list(string))` | no | IAM bindings applied to the created service account resource, keyed by role. Default is `{}`. |
| `generate_key` | `bool` | no | Whether to create a `yandex_iam_service_account_key` for the service account. Default is `false`. |

### `roles`

Map key: arbitrary binding name used only inside Terraform.

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `role` | `string` | yes | Folder-level IAM role to assign. |
| `members` | `list(string)` | yes | Members that should receive the role. |
