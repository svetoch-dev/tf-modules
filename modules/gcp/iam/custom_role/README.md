# GCP IAM Custom Role Module

Creates a custom IAM role at the project level with a user-defined set of permissions.

## Usage

```hcl
module "custom_role" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/iam/custom_role?ref=master"

  name        = "exampleCustomRole"
  title       = "Example Custom Role"
  description = "A custom role with limited compute permissions"
  permissions = [
    "compute.instances.get",
    "compute.instances.list",
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
| `name` | Custom role name | `string` | n/a | yes |
| `title` | Custom role title | `string` | n/a | yes |
| `description` | Custom role description | `string` | n/a | yes |
| `permissions` | Custom role permissions | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `custom_role` | Custom role definition |
