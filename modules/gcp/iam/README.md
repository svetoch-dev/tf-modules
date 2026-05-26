# GCP IAM Module

Orchestrates GCP IAM resources by composing the `custom_role`, `role`, and `service_account` submodules. Creates custom roles, project-level role bindings, and service accounts with optional keys and bindings.

## Usage

```hcl
module "iam" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/iam?ref=master"

  project_id = "my-gcp-project"

  custom_roles = {
    customViewer = {
      title       = "Custom Viewer"
      description = "A custom viewer role"
      permissions = [
        "compute.instances.get",
        "compute.instances.list",
      ]
    }
  }

  roles = {
    storageViewer = {
      role    = "roles/storage.objectViewer"
      members = [
        "user:alice@example.com",
      ]
    }
  }

  service_accounts = {
    ci_cd = {
      description = "Service account for CI/CD"
      roles = [
        "roles/storage.admin",
      ]
      generate_key = true
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| google | < 7.0.0 |
| google-beta | < 7.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_id` | GCP project id | `string` | n/a | yes |
| `custom_roles` | Map of custom roles to create | `map(object)` | n/a | yes |
| `roles` | Map of project-level role bindings | `map(object)` | n/a | yes |
| `service_accounts` | Map of service accounts to create | `map(object)` | n/a | yes |

## Type Details

### `custom_roles`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | no | Custom role ID. Defaults to the map key. |
| `title` | `string` | yes | Custom role title. |
| `description` | `string` | yes | Custom role description. |
| `permissions` | `list(string)` | no | List of permissions. Defaults to `[]`. |

### `roles`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `role` | `string` | yes | IAM role to assign. |
| `members` | `list(string)` | yes | List of IAM members to bind to the role. |

### `service_accounts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | no | Service account name. Defaults to the map key. |
| `description` | `string` | yes | Service account description. |
| `roles` | `list(string)` | no | Project-level roles to assign to the service account. Defaults to `[]`. |
| `sa_iam_bindings` | `map(list(string))` | no | IAM bindings on the service account itself. Defaults to `{}`. |
| `generate_key` | `bool` | no | Whether to generate a key for the service account. Defaults to `true`. |

## Outputs

| Name | Description |
|------|-------------|
| `service_accounts` | Map of created service account objects keyed by name. |
| `custom_roles` | Map of created custom role objects keyed by name. |
