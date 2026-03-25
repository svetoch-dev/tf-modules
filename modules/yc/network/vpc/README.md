# Yandex VPC Network Module

Creates a `yandex_vpc_network` resource.

## Usage

```hcl
module "vpc" {
  source = "./modules/yc/network/vpc"

  folder_id    = "b1gxxxxxxxxxxxxxxx"
  network_name = "example-network"
  description  = "Shared VPC network"

  labels = {
    env  = "dev"
    team = "platform"
  }

  timeouts = {
    create = "5m"
    update = "5m"
    delete = "5m"
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
| `folder_id` | The ID of the folder where this VPC will be created. | `string` | n/a | yes |
| `network_name` | The name of the network being created. | `string` | n/a | yes |
| `description` | An optional description of this resource. | `string` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the network. | `map(string)` | `{}` | no |
| `timeouts` | Custom timeouts for the VPC network resource. | `object({ create = optional(string), update = optional(string), delete = optional(string) })` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The VPC resource being created. |

## Notes

- The module exposes all currently settable attributes of `yandex_vpc_network`.
- Read-only resource fields such as `id`, `created_at`, `default_security_group_id`, and `subnet_ids` are available through the `this` output.
