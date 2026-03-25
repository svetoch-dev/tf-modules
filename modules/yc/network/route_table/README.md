# Yandex Route Table Module

Creates a `yandex_vpc_route_table` resource.

## Usage

```hcl
module "route_table" {
  source = "./modules/yc/network/route_table"

  folder_id  = "b1gxxxxxxxxxxxxxxx"
  network_id = "enpxxxxxxxxxxxxxxx"
  name       = "example-route-table"
  description = "Routes for private subnets"

  labels = {
    env = "dev"
  }

  static_routes = [
    {
      destination_prefix = "0.0.0.0/0"
      gateway_id         = "enpgwxxxxxxxxxxxxxx"
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
| `folder_id` | The folder where the route table will be created. | `string` | n/a | yes |
| `network_id` | The network where the route table will be created. | `string` | n/a | yes |
| `name` | Route table name. | `string` | n/a | yes|
| `description` | Route table description. | `string` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the route table. | `map(string)` | `{}` | no |
| `static_routes` | Static routes to create in the route table. | <pre>list(object({<br>  destination_prefix = string<br>  gateway_id         = optional(string)<br>  next_hop_address   = optional(string)<br>}))</pre> | `[]` | no |
| `timeouts` | Custom timeouts for the route table resource. | <pre>object({<br>  create = optional(string)<br>  update = optional(string)<br>  delete = optional(string)<br>})</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The route table resource. |

## Notes

- The module exposes all currently settable attributes of `yandex_vpc_route_table`.
- Each `static_route` entry should set only one of `gateway_id` or `next_hop_address`.
