# Kubernetes Namespaces Module

Creates Kubernetes namespaces from a map of namespace definitions.

## Usage

```hcl
module "namespaces" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/k8s/namespaces?ref=master"

  namespaces = {
    application = {
      name = "application"
      labels = {
        env = "dev"
      }
      annotations = {
        owner = "platform"
      }
    }

    monitoring = {
      name = "monitoring"
      labels = {
        app = "monitoring"
      }
    }
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
| `namespaces` | Map of Kubernetes namespaces to create. Null map values are ignored. | `map(object)` | n/a | yes |

## Notes

- The map key is used only as the Terraform `for_each` key. The Kubernetes namespace name is taken from `namespaces[*].name`.
- Set stable map keys to avoid Terraform destroying and recreating namespace resources when only local labels change.
- `annotations` and `labels` default to empty maps when omitted.

## Type Details

### `namespaces`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | yes | Kubernetes namespace name. |
| `annotations` | `map(string)` | no | Annotations assigned to the namespace metadata. |
| `labels` | `map(string)` | no | Labels assigned to the namespace metadata. |
