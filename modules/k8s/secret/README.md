# Kubernetes Secret Module

Creates a Kubernetes secret.

## Usage

```hcl
module "app_secret" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/k8s/secret?ref=master"

  name      = "app-secret"
  namespace = "application"

  labels = {
    app = "example"
  }

  annotations = {
    owner = "platform"
  }

  data = {
    username = "example"
    password = "change-me"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| kubernetes | 2.38.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `data` | Secret data as key/value pairs. | `map(string)` | n/a | yes |
| `name` | Kubernetes secret name. | `string` | n/a | yes |
| `namespace` | Kubernetes namespace where the secret will be created. | `string` | n/a | yes |
| `annotations` | Annotations assigned to the secret metadata. | `map(string)` | `{}` | no |
| `labels` | Labels assigned to the secret metadata. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `secret` | The Kubernetes secret resource. |

## Notes

- The module creates a default `Opaque` Kubernetes secret because no explicit secret type is set.
- Values in `data` are stored in Terraform state. Use appropriate state encryption and access controls for sensitive values.
- The target namespace must already exist before applying this module.
