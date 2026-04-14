# Yandex IAM Module

Creates Yandex Cloud folder IAM bindings, OIDC workload identity federations, and service accounts from map-based configuration.

## Usage

```hcl
module "iam" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/iam?ref=master"

  folder_id = "b1gxxxxxxxxxxxxxxx"

  oidc_federations = {
    github-actions = {
      issuer    = "https://token.actions.githubusercontent.com"
      jwks_url  = "https://token.actions.githubusercontent.com/.well-known/jwks"
      audiences = [
        "https://github.com/svetoch-dev",
        "sts.yandexcloud.net",
      ]
      description = "OIDC federation for GitHub Actions"
      labels = {
        env = "prod"
      }
    }
  }

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
      federated_credentials = {
        k8s = {
          federation_id       = "aje6o8f1i2example"
          external_subject_id = "system:serviceaccount:argocd:argocd"
        }
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
| yandex | 0.195.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `folder_id` | Yandex Cloud folder ID where IAM resources will be managed. | `string` | n/a | yes |
| `oidc_federations` | Map of OIDC federation definitions keyed by federation name. | `map(object(...))` | `{}` | no |
| `service_accounts` | Map of service account definitions keyed by service account name. | `map(object(...))` | `{}` | no |
| `roles` | Map of folder IAM role assignments keyed by arbitrary binding name. | `map(object(...))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `oidc_federations` | Map of created OIDC federations keyed by federation name. Each value matches the `oidc_federation` submodule `this` output. |
| `service_accounts` | Map of created service accounts keyed by service account name. Each value matches the `service_account` submodule `this` output and includes `key` and `federated_credentials` fields. |

## Notes

- Each entry in `oidc_federations` creates a nested `modules/yc/iam/oidc_federation` module.
- `service_accounts` are created before top-level `roles`, so role bindings can safely reference service accounts created by the same module call.
- Each entry in `roles` creates a nested `modules/yc/iam/role` module.
- Each entry in `service_accounts` creates a nested `modules/yc/iam/service_account` module.
- `service_accounts[*].federated_credentials` is passed through to the `modules/yc/iam/service_account` submodule and creates one workload identity federated credential per map entry.
- Service account IAM member strings and folder IAM member strings must use Yandex Cloud IAM member format such as `serviceAccount:<id>`, `userAccount:<login>`, or `group:<id>`.
- When `generate_key = true`, the generated private key is exposed through the `service_accounts` output and should be handled as sensitive infrastructure data.

## Type Details

### `oidc_federations`

Map key: federation name.

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `issuer` | `string` | yes | The OIDC issuer URL used to validate the incoming token. |
| `jwks_url` | `string` | yes | The URL used to fetch the OIDC provider JSON Web Key Set. |
| `audiences` | `list(string)` | yes | Allowed audience values for incoming OIDC tokens. |
| `description` | `string` | no | Optional description for the federation. |
| `disabled` | `bool` | no | Whether the federation is disabled. Default is `false`. |
| `labels` | `map(string)` | no | Labels assigned to the federation. Default is `{}`. |
| `timeouts` | `object({ create = optional(string), update = optional(string), delete = optional(string) })` | no | Custom timeouts for federation operations. |

### `service_accounts`

Map key: service account name.

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `description` | `string` | yes | Description for the service account being created. |
| `roles` | `list(string)` | no | Folder-level IAM roles to grant to the created service account. Default is `[]`. |
| `sa_iam_bindings` | `map(list(string))` | no | IAM bindings applied to the created service account resource, keyed by role. Default is `{}`. |
| `generate_key` | `bool` | no | Whether to create a `yandex_iam_service_account_key` for the service account. Default is `false`. |
| `federated_credentials` | `map(object({ federation_id = string, external_subject_id = string }))` | no | Federated credentials to create for the service account, keyed by an arbitrary local name. |

### `service_accounts[*].federated_credentials`

Map key: arbitrary local name used only inside Terraform.

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `federation_id` | `string` | yes | ID of the workload identity federation that issues the external identity. |
| `external_subject_id` | `string` | yes | External subject value from the federated identity token to bind to the service account. |

### `roles`

Map key: arbitrary binding name used only inside Terraform.

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `role` | `string` | yes | Folder-level IAM role to assign. |
| `members` | `list(string)` | yes | Members that should receive the role. |
