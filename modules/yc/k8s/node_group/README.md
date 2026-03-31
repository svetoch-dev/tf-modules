# Yandex Kubernetes Node Group Module

Creates a `yandex_kubernetes_node_group` resource.

## Usage

```hcl
module "node_group" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/k8s/node_group?ref=master"

  cluster_id  = "catxxxxxxxxxxxxxxx"
  name        = "example-node-group"
  description = "General workload nodes"
  version     = "1.30"

  labels = {
    env = "dev"
  }

  node_labels = {
    "node-role" = "general"
  }

  node_taints             = []
  allowed_unsafe_sysctls  = []
  variables               = {}

  allocation_policy = {
    location = [
      {
        zone      = "ru-central1-a"
        subnet_id = "e9bxxxxxxxxxxxxxxx"
      }
    ]
  }

  instance_template = {
    platform_id = "standard-v2"
    labels = {
      env = "dev"
    }
    network_interface = [
      {
        nat        = true
        subnet_ids = ["e9bxxxxxxxxxxxxxxx"]
      }
    ]
    resources = {
      cores  = 2
      memory = 4
    }
    boot_disk = {
      type = "network-hdd"
      size = 64
    }
    scheduling_policy = {
      preemptible = false
    }
    container_runtime = {
      type = "containerd"
    }
  }

  scale_policy = {
    fixed_scale = {
      size = 1
    }
  }

  maintenance_policy = {
    auto_upgrade = true
    auto_repair  = true
    maintenance_window = [
      {
        day        = "monday"
        start_time = "15:00"
        duration   = "3h"
      }
    ]
  }

  workload_identity_federation = {
    enabled = true
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
| `cluster_id` | The ID of the Kubernetes cluster that this node group belongs to. | `string` | n/a | yes |
| `allocation_policy` | Subnets and zones that will be used by node group compute instances. | `object` | n/a | yes |
| `instance_template` | Template used to create compute instances in this Kubernetes node group. | `object` | n/a | yes |
| `scale_policy` | Scale policy of the node group. | `object` | n/a | yes |
| `allowed_unsafe_sysctls` | A list of allowed unsafe sysctl parameters for this node group. | `list(string)` | `[]` | no |
| `deploy_policy` | Deploy policy of the node group. | `object` | `null` | no |
| `description` | The node group description. | `string` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the node group resource. | `map(string)` | `{}` | no |
| `maintenance_policy` | Maintenance policy for this Kubernetes node group. | `object` | `null` | no |
| `name` | The node group name. | `string` | `null` | no |
| `node_labels` | A set of key/value label pairs assigned to all nodes in the node group. | `map(string)` | `{}` | no |
| `node_taints` | A list of Kubernetes taints applied to all nodes in the node group. | `list(string)` | `[]` | no |
| `variables` | Variables for templating as key/value pairs. | `map(string)` | `{}` | no |
| `version` | Kubernetes version for the node group. | `string` | `null` | no |
| `workload_identity_federation` | Workload Identity Federation configuration. | `object` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The Kubernetes node group resource. |

## Notes

- The module exposes all currently documented settable attributes of `yandex_kubernetes_node_group`.
- Provider-computed attributes such as `created_at`, `id`, `instance_group_id`, `status`, and `version_info` are returned through the `this` output.
- Some nested blocks are accepted as optional here because the provider performs the final validation for valid combinations.

## Type Details

### `allocation_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `location` | `list(object)` | yes | Zones and optional subnets for node placement. |

### `allocation_policy.location[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `zone` | `string` | yes | Availability zone for the node placement. |
| `subnet_id` | `string` | no | Subnet ID in the same zone. |

### `deploy_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `max_expansion` | `number` | yes | Maximum temporary instances above target size during update. |
| `max_unavailable` | `number` | yes | Maximum running instances that can be taken offline during update. |

### `instance_template`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `labels` | `map(string)` | no | Labels assigned to compute instances. |
| `metadata` | `map(string)` | no | Metadata assigned to compute instances. |
| `name` | `string` | no | Name template for compute instances. |
| `nat` | `bool` | no | Enables NAT for compute instances. |
| `network_acceleration_type` | `string` | no | Network acceleration type. |
| `platform_id` | `string` | no | Hardware platform ID. |
| `reserved_instance_pool_id` | `string` | no | Reserved instance pool ID. |
| `boot_disk` | `object` | no | Boot disk configuration. |
| `container_network` | `object` | no | Container network configuration. |
| `container_runtime` | `object` | no | Container runtime configuration. |
| `gpu_settings` | `object` | no | GPU settings. |
| `network_interface` | `list(object)` | no | Network interfaces attached to the instances. |
| `placement_policy` | `object` | no | Placement policy configuration. |
| `resources` | `object` | no | Instance resource configuration. |
| `scheduling_policy` | `object` | no | Scheduling policy configuration. |

### `instance_template.boot_disk`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `size` | `number` | yes | Boot disk size in GB. |
| `type` | `string` | yes | Boot disk type. |

### `instance_template.container_network`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `pod_mtu` | `number` | no | MTU for pods. |

### `instance_template.container_runtime`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `type` | `string` | yes | Container runtime type. |

### `instance_template.gpu_settings`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `gpu_cluster_id` | `string` | no | GPU cluster ID. |
| `gpu_environment` | `string` | no | GPU environment. |

### `instance_template.network_interface[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `ipv4` | `bool` | no | Allocate an IPv4 address. |
| `ipv6` | `bool` | no | Allocate an IPv6 address. |
| `nat` | `bool` | no | Allocate a public NAT address. |
| `security_group_ids` | `set(string)` | no | Security groups for the interface. |
| `subnet_ids` | `set(string)` | yes | Subnet IDs for the interface. |
| `ipv4_dns_records` | `list(object)` | no | IPv4 DNS records to create. |
| `ipv6_dns_records` | `list(object)` | no | IPv6 DNS records to create. |

### `instance_template.network_interface[].ipv4_dns_records[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `dns_zone_id` | `string` | no | DNS zone ID. |
| `fqdn` | `string` | yes | DNS record FQDN. |
| `ptr` | `bool` | no | Whether to create a PTR record. |
| `ttl` | `number` | no | TTL for the DNS record. |

### `instance_template.network_interface[].ipv6_dns_records[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `dns_zone_id` | `string` | no | DNS zone ID. |
| `fqdn` | `string` | yes | DNS record FQDN. |
| `ptr` | `bool` | no | Whether to create a PTR record. |
| `ttl` | `number` | no | TTL for the DNS record. |

### `instance_template.placement_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `placement_group_id` | `string` | yes | Placement group ID for the instances. |

### `instance_template.resources`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `core_fraction` | `number` | no | Baseline core performance as a percent. |
| `cores` | `number` | no | Number of CPU cores. |
| `gpus` | `number` | no | Number of GPUs. |
| `memory` | `number` | no | Memory size. |

### `instance_template.scheduling_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `preemptible` | `bool` | no | Whether the instances are preemptible. |

### `maintenance_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `auto_repair` | `bool` | no | Whether the node group can be repaired automatically. |
| `auto_upgrade` | `bool` | no | Whether the node group can be upgraded automatically. |
| `maintenance_window` | `list(object)` | no | Allowed maintenance windows. |

### `maintenance_policy.maintenance_window[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `day` | `string` | no | Day of week for maintenance. |
| `duration` | `string` | yes | Duration of maintenance from start time. |
| `start_time` | `string` | yes | Start time of maintenance window. |

### `scale_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `auto_scale` | `object` | no | Autoscaling configuration. |
| `fixed_scale` | `object` | no | Fixed-size scaling configuration. |

### `scale_policy.auto_scale`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `initial` | `number` | yes | Initial node count. |
| `max` | `number` | yes | Maximum node count. |
| `min` | `number` | yes | Minimum node count. |

### `scale_policy.fixed_scale`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `size` | `number` | yes | Fixed node count. |

### `workload_identity_federation`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enabled` | `bool` | yes | Whether Workload Identity Federation is enabled. |
