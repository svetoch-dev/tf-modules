# Yandex IAM Service Account Module

Creates a `yandex_iam_service_account` and can optionally grant folder roles, create a key, assign IAM members on the service account itself, and configure workload identity federated credentials.

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

  federated_credentials = {
    k8s = {
      federation_id       = "aje6o8f1i2example"
      external_subject_id = "system:serviceaccount:argocd:argocd"
    }
  }

  generate_key = true
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
| `folder_id` | Yandex Cloud folder ID where the service account will be created. | `string` | n/a | yes |
| `name` | Service account name. | `string` | n/a | yes |
| `description` | Service account description. | `string` | n/a | yes |
| `roles` | Folder-level IAM roles to grant to the created service account. | `list(string)` | `[]` | no |
| `sa_iam_bindings` | IAM roles and members to grant on the created service account resource. | `map(list(string))` | `{}` | no |
| `federated_credentials` | Federated credentials to create for the service account, keyed by an arbitrary local name. | `map(object({ federation_id = string, external_subject_id = string }))` | `{}` | no |
| `generate_key` | Whether to create a `yandex_iam_service_account_key` for the service account. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | Service account object merged with a `key` field and a `federated_credentials` map containing created federated credential resources. |

## Notes

- The module creates one `yandex_resourcemanager_folder_iam_member` resource per entry in `roles`.
- The module creates one `yandex_iam_service_account_iam_member` resource per member entry across `sa_iam_bindings`.
- The module creates one `yandex_iam_workload_identity_federated_credential` resource per entry in `federated_credentials`.
- `roles` are deduplicated because the module uses `toset(var.roles)`.
- `sa_iam_bindings` members must use Yandex Cloud IAM member format such as `serviceAccount:<id>`, `userAccount:<login>`, or `group:<id>`.
- Each `federated_credentials` entry must provide the target `federation_id` and the upstream token subject value in `external_subject_id`.
- When `generate_key = true`, the private key material is exposed through the module output and should be handled as sensitive infrastructure data.

## Type Details

### `federated_credentials`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `federation_id` | `string` | yes | ID of the workload identity federation that issues the external identity. |
| `external_subject_id` | `string` | yes | External subject value from the federated identity token to bind to this service account. |
