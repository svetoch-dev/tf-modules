# Yandex IAM Service Account Module

Creates a `yandex_iam_service_account` and can optionally grant folder roles, create a key, and assign IAM members on the service account itself.

## Usage

```hcl
module "service_account" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/iam/service_account?ref=master"

  folder_id   = "b1gxxxxxxxxxxxxxxx"
  name        = "ci-runner"
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
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| yandex | 0.189.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `folder_id` | Yandex Cloud folder ID where the service account will be created. | `string` | n/a | yes |
| `name` | Service account name. | `string` | n/a | yes |
| `description` | Service account description. | `string` | n/a | yes |
| `roles` | Folder-level IAM roles to grant to the created service account. | `list(string)` | `[]` | no |
| `sa_iam_bindings` | IAM roles and members to grant on the created service account resource. | `map(list(string))` | `{}` | no |
| `generate_key` | Whether to create a `yandex_iam_service_account_key` for the service account. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | Service account object merged with a `key` field containing the generated private key or an empty string. |

## Notes

- The module creates one `yandex_resourcemanager_folder_iam_member` resource per entry in `roles`.
- The module creates one `yandex_iam_service_account_iam_member` resource per member entry across `sa_iam_bindings`.
- `roles` are deduplicated because the module uses `toset(var.roles)`.
- `sa_iam_bindings` members must use Yandex Cloud IAM member format such as `serviceAccount:<id>`, `userAccount:<login>`, or `group:<id>`.
- When `generate_key = true`, the private key material is exposed through the module output and should be handled as sensitive infrastructure data.
