# GCP IAM Role Binding Module

Assigns a single IAM role to multiple members at the project level.

## Usage

```hcl
module "role_binding" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/iam/role?ref=master"

  project_id = "my-gcp-project"
  role       = "roles/compute.viewer"
  members = [
    "user:alice@example.com",
    "group:developers@example.com",
  ]
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
| `role` | IAM role | `string` | n/a | yes |
| `members` | Members of specified role | `list(string)` | n/a | yes |

## Outputs

None.
