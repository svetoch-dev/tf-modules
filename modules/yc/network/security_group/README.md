# Yandex Security Group Module

Creates a `yandex_vpc_security_group` resource.

## Usage

```hcl
module "security_group" {
  source = "./modules/yc/network/security_group"

  folder_id  = "b1gxxxxxxxxxxxxxxx"
  network_id = "enpxxxxxxxxxxxxxxx"
  name       = "example-security-group"
  description = "Security group for application nodes"

  labels = {
    env = "dev"
  }

  ingress = [
    {
      protocol       = "TCP"
      port           = 443
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress = [
    {
      protocol       = "ANY"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  ]

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
| `folder_id` | The folder where the security group will be created. | `string` | n/a | yes |
| `network_id` | The network where the security group will be created. | `string` | n/a | yes |
| `name` | Security group name. | `string` | n/a | yes |
| `description` | Security group description. | `string` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the security group. | `map(string)` | `{}` | no |
| `ingress` | Ingress rules for the security group. | `list(object)` | `[]` | no |
| `egress` | Egress rules for the security group. | `list(object)` | `[]` | no |
| `timeouts` | Custom timeouts for the security group resource. | `object` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The security group resource. |

## Notes

- The module exposes all currently settable attributes of `yandex_vpc_security_group`.
- Rule `labels` are supported by the provider schema and are passed through directly.
- The provider currently notes that `v6_cidr_blocks` is not yet supported in practice, even though the field exists in the schema.

## Type Details

### `ingress[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `description` | `string` | no | Rule description. |
| `from_port` | `number` | no | Minimum port number. |
| `labels` | `map(string)` | no | Labels assigned to the rule. |
| `port` | `number` | no | Single port number. |
| `predefined_target` | `string` | no | Special predefined target such as `self_security_group`. |
| `protocol` | `string` | yes | Protocol, for example `TCP`, `UDP`, or `ANY`. |
| `security_group_id` | `string` | no | Target security group ID. |
| `to_port` | `number` | no | Maximum port number. |
| `v4_cidr_blocks` | `list(string)` | no | IPv4 CIDR ranges for the rule. |
| `v6_cidr_blocks` | `list(string)` | no | IPv6 CIDR ranges for the rule. |

### `egress[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `description` | `string` | no | Rule description. |
| `from_port` | `number` | no | Minimum port number. |
| `labels` | `map(string)` | no | Labels assigned to the rule. |
| `port` | `number` | no | Single port number. |
| `predefined_target` | `string` | no | Special predefined target such as `self_security_group`. |
| `protocol` | `string` | yes | Protocol, for example `TCP`, `UDP`, or `ANY`. |
| `security_group_id` | `string` | no | Target security group ID. |
| `to_port` | `number` | no | Maximum port number. |
| `v4_cidr_blocks` | `list(string)` | no | IPv4 CIDR ranges for the rule. |
| `v6_cidr_blocks` | `list(string)` | no | IPv6 CIDR ranges for the rule. |

### `timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |
