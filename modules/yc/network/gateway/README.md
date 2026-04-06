# Yandex Gateway Module

Creates a `yandex_vpc_gateway` resource configured as a shared egress gateway.

## Usage

```hcl
module "nat" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/network/gateway?ref=master"

  folder_id   = "b1gxxxxxxxxxxxxxxx"
  name        = "example-nat"
  description = "Shared egress gateway"

  labels = {
    env = "dev"
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
| yandex | 0.195.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `folder_id` | The folder where the NAT resources will be created. | `string` | n/a | yes |
| `name` | NAT gateway name. | `string` | n/a | yes |
| `description` | NAT gateway description. | `string` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the NAT gateway. | `map(string)` | `{}` | no |
| `timeouts` | Custom timeouts for the NAT gateway resource. | `object` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The NAT gateway resource. |

## Notes

- The module exposes all currently settable attributes of `yandex_vpc_gateway`.
- For this resource type, `shared_egress_gateway` is the gateway mode currently supported by the provider and is enabled internally by the module.

## Type Details

### `timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |
