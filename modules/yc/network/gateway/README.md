# Yandex Gateway Module

Creates a `yandex_vpc_gateway` resource configured as a shared egress gateway.

## Usage

```hcl
module "nat" {
  source = "./modules/yc/network/nat"

  folder_id   = "b1gxxxxxxxxxxxxxxx"
  name        = "example-nat"
  description = "Shared egress gateway"

  labels = {
    env = "dev"
  }

  shared_egress_gateway = {}

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
| `folder_id` | The folder where the NAT resources will be created. | `string` | n/a | yes |
| `name` | NAT gateway name. | `string` | `null` | no |
| `description` | NAT gateway description. | `string` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the NAT gateway. | `map(string)` | `{}` | no |
| `shared_egress_gateway` | Shared egress gateway configuration. Keep non-null to create a NAT gateway of this type. | `object({})` | `{}` | no |
| `timeouts` | Custom timeouts for the NAT gateway resource. | `object({ create = optional(string), update = optional(string), delete = optional(string) })` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The NAT gateway resource. |

## Notes

- The module exposes all currently settable attributes of `yandex_vpc_gateway`.
- For this resource type, `shared_egress_gateway` is the gateway mode currently supported by the provider.
