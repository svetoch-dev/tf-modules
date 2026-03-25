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
| `name` | Security group name. | `string` | `null` | no |
| `description` | Security group description. | `string` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the security group. | `map(string)` | `{}` | no |
| `ingress` | Ingress rules for the security group. | `list(object({ description = optional(string), from_port = optional(number), labels = optional(map(string)), port = optional(number), predefined_target = optional(string), protocol = string, security_group_id = optional(string), to_port = optional(number), v4_cidr_blocks = optional(list(string)), v6_cidr_blocks = optional(list(string)) }))` | `[]` | no |
| `egress` | Egress rules for the security group. | `list(object({ description = optional(string), from_port = optional(number), labels = optional(map(string)), port = optional(number), predefined_target = optional(string), protocol = string, security_group_id = optional(string), to_port = optional(number), v4_cidr_blocks = optional(list(string)), v6_cidr_blocks = optional(list(string)) }))` | `[]` | no |
| `timeouts` | Custom timeouts for the security group resource. | `object({ create = optional(string), update = optional(string), delete = optional(string) })` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The security group resource. |

## Notes

- The module exposes all currently settable attributes of `yandex_vpc_security_group`.
- Rule `labels` are supported by the provider schema and are passed through directly.
- The provider currently notes that `v6_cidr_blocks` is not yet supported in practice, even though the field exists in the schema.
