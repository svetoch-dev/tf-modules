# GCP IAM Service Account Module

Creates a Google Cloud service account with optional key generation, project-level role bindings, and service account-level IAM bindings.

## Usage

```hcl
module "service_account" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/iam/service_account?ref=master"

  project_id  = "my-gcp-project"
  name        = "my-service-account"
  description = "Service account for CI/CD pipeline"

  roles = [
    "roles/storage.objectViewer",
    "roles/compute.instanceAdmin",
  ]

  sa_iam_bindings = {
    "roles/iam.serviceAccountUser" = [
      "user:alice@example.com",
    ]
  }

  generate_key = true
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
| `name` | Service account name | `string` | n/a | yes |
| `description` | Service account description | `string` | n/a | yes |
| `roles` | Service account roles | `list(string)` | `[]` | no |
| `sa_iam_bindings` | Service account IAM bindings | `map(list(string))` | `{}` | no |
| `generate_key` | Generate key or not for this service account | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `service_account` | Service account object |
