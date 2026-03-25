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
| `static_routes` | Static routes to create in the route table. | `list(object)` | `[]` | no |
| `timeouts` | Custom timeouts for the route table resource. | `object` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The route table resource. |

## Notes

- The module exposes all currently settable attributes of `yandex_vpc_route_table`.
- Each `static_route` entry should set only one of `gateway_id` or `next_hop_address`.

## Type Details

### `static_routes[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `destination_prefix` | `string` | yes | Route prefix in CIDR notation. |
| `gateway_id` | `string` | no | Gateway ID used as next hop. |
| `next_hop_address` | `string` | no | Explicit next-hop IP address. |

### `timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `update` | `string` | no | Timeout for update operations. |
| `delete` | `string` | no | Timeout for delete operations. |
