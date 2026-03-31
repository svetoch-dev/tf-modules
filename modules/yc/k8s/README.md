# Yandex Kubernetes Module

Creates a Kubernetes cluster with zero or more node groups

## Usage

```hcl
module "k8s" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/k8s?ref=master"

  name                    = "example-cluster"
  network_id              = "enpxxxxxxxxxxxxxxx"
  service_account_id      = "ajexxxxxxxxxxxxxxx"
  node_service_account_id = "ajeyyyyyyyyyyyyyyy"

  master = {
    version   = "1.30"
    public_ip = true
    zonal = {
      zone      = "ru-central1-a"
      subnet_id = "e9bxxxxxxxxxxxxxxx"
    }
  }

  node_groups = {
    general = {
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
        container_runtime = {
          type = "containerd"
        }
      }
      scale_policy = {
        fixed_scale = {
          size = 1
        }
      }
    }
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
| `network_id` | The ID of the VPC network where the Kubernetes cluster will be created. | `string` | n/a | yes |
| `service_account_id` | Service account used for provisioning Compute Cloud and VPC resources for the cluster. | `string` | n/a | yes |
| `node_service_account_id` | Service account used by worker nodes to access registries, logs, and metrics. | `string` | n/a | yes |
| `master` | Kubernetes master configuration. | `object` | n/a | yes |
| `admins` | IAM member strings that should get Kubernetes admin access. Supports standard Yandex Cloud IAM member formats such as `serviceAccount:<id>`, `userAccount:<login>`, `group:<id>`, and also `serviceAccountName:` / `userAccountName:` prefixes resolved by the module. | `list(string)` | `[]` | no |
| `description` | The Kubernetes cluster description. | `string` | `null` | no |
| `editors` | IAM member strings that should get Kubernetes editor access. Supports standard Yandex Cloud IAM member formats such as `serviceAccount:<id>`, `userAccount:<login>`, `group:<id>`, and also `serviceAccountName:` / `userAccountName:` prefixes resolved by the module. | `list(string)` | `[]` | no |
| `folder_id` | The folder where the Kubernetes cluster will be created. | `string` | `null` | no |
| `kms_provider` | Cluster KMS provider configuration. | `object` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the cluster. | `map(string)` | `{}` | no |
| `name` | The Kubernetes cluster name. | `string` | `null` | no |
| `network_policy_provider` | Network policy provider for the cluster. | `string` | `"CALICO"` | no |
| `node_groups` | Map of Kubernetes node groups to create in the cluster. | `map(object)` | `{}` | no |
| `node_ipv4_cidr_mask_size` | Mask size assigned to each node for pod networking. | `number` | `null` | no |
| `pod_ipv4_range` | CIDR block for pod IP addresses. | `string` | `null` | no |
| `pod_ipv6_range` | CIDR block for pod IPv6 addresses. | `string` | `null` | no |
| `release_channel` | Cluster release channel. | `string` | `null` | no |
| `service_ipv4_range` | CIDR block for service IP addresses. | `string` | `null` | no |
| `service_ipv6_range` | CIDR block for service IPv6 addresses. | `string` | `null` | no |
| `viewers` | IAM member strings that should get Kubernetes viewer access. Supports standard Yandex Cloud IAM member formats such as `serviceAccount:<id>`, `userAccount:<login>`, `group:<id>`, and also `serviceAccountName:` / `userAccountName:` prefixes resolved by the module. | `list(string)` | `[]` | no |
| `workload_identity_federation` | Workload Identity Federation configuration for the cluster. | `object` | `null` | no |

## Notes

- This module composes the `cluster` and `node_group` submodules and forwards the cluster ID automatically to each node group.
- Exactly one of `master.zonal`, `master.regional`, or `master.master_location` must be set.
- Each node group must set exactly one of `scale_policy.auto_scale` or `scale_policy.fixed_scale`.

## Type Details

### `master`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `etcd_cluster_size` | `number` | no | Number of etcd nodes for the master. |
| `public_ip` | `bool` | no | Whether the master endpoint is publicly accessible. |
| `security_group_ids` | `set(string)` | no | Security groups attached to the master. |
| `version` | `string` | no | Kubernetes version for the master. |
| `maintenance_policy` | `object` | no | Master maintenance policy configuration. |
| `master_location` | `list(object)` | no | Explicit master locations. |
| `master_logging` | `object` | no | Master logging configuration. |
| `network_implementation` | `object` | no | Cluster network implementation. |
| `regional` | `object` | no | Regional master placement. |
| `scale_policy` | `object` | no | Master scaling policy. |
| `zonal` | `object` | no | Zonal master placement. |

### `master.maintenance_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `auto_upgrade` | `bool` | no | Whether master auto-upgrade is enabled. |
| `maintenance_window` | `list(object)` | no | Allowed maintenance windows. |

### `master.maintenance_policy.maintenance_window[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `day` | `string` | no | Day of week for maintenance. |
| `duration` | `string` | yes | Duration of the maintenance window. |
| `start_time` | `string` | yes | Start time of the maintenance window. |

### `master.master_location[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `zone` | `string` | yes | Availability zone for the master location. |
| `subnet_id` | `string` | yes | Subnet ID for the master location. |

### `master.master_logging`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `audit_enabled` | `bool` | no | Enables audit logs. |
| `cluster_autoscaler_enabled` | `bool` | no | Enables cluster autoscaler logs. |
| `enabled` | `bool` | no | Enables master logging. |
| `events_enabled` | `bool` | no | Enables Kubernetes events logging. |
| `folder_id` | `string` | no | Folder for the destination log group. |
| `kube_apiserver_enabled` | `bool` | no | Enables Kubernetes API server logs. |
| `log_group_id` | `string` | no | Existing log group ID for master logs. |

### `master.network_implementation`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `cilium` | `object` | no | Enables the Cilium network implementation. |

### `master.network_implementation.cilium`

This object is empty. Its presence enables Cilium.

### `master.regional`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `region` | `string` | yes | Region for the regional master. |
| `location` | `list(object)` | yes | Locations used by the regional master. |

### `master.regional.location[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `zone` | `string` | yes | Availability zone for the regional master location. |
| `subnet_id` | `string` | yes | Subnet ID for the regional master location. |

### `master.scale_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `auto_scale` | `object` | no | Autoscaling configuration for the master. |

### `master.scale_policy.auto_scale`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `min_resource_preset_id` | `string` | yes | Minimum master resource preset ID. |

### `master.zonal`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `subnet_id` | `string` | no | Subnet ID for the zonal master. |
| `zone` | `string` | yes | Availability zone for the zonal master. |

### `kms_provider`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `key_id` | `string` | yes | KMS key ID used for secrets encryption. |

### `workload_identity_federation`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enabled` | `bool` | yes | Whether Workload Identity Federation is enabled for the cluster. |

### `node_groups`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | no | The node group name. |
| `description` | `string` | no | The node group description. |
| `version` | `string` | no | Kubernetes version for the node group. |
| `labels` | `map(string)` | no | Labels assigned to the node group resource. |
| `node_labels` | `map(string)` | no | Labels assigned to all nodes in the node group. |
| `node_taints` | `list(string)` | no | Kubernetes taints applied to all nodes in the node group. |
| `allowed_unsafe_sysctls` | `list(string)` | no | Allowed unsafe sysctl parameters for the node group. |
| `variables` | `map(string)` | no | Variables for templating as key/value pairs. |
| `allocation_policy` | `object` | yes | Subnets and zones used by node group compute instances. |
| `deploy_policy` | `object` | no | Deploy policy of the node group. |
| `instance_template` | `object` | yes | Template used to create compute instances in the node group. |
| `maintenance_policy` | `object` | no | Maintenance policy for the node group. |
| `scale_policy` | `object` | yes | Scale policy of the node group. |
| `workload_identity_federation` | `object` | no | Workload Identity Federation configuration for the node group. |

### `node_groups{}.allocation_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `location` | `list(object)` | yes | Zones and optional subnets for node placement. |

### `node_groups{}.allocation_policy.location[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `zone` | `string` | yes | Availability zone for the node placement. |
| `subnet_id` | `string` | no | Subnet ID in the same zone. |

### `node_groups{}.deploy_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `max_expansion` | `number` | yes | Maximum temporary instances above target size during update. |
| `max_unavailable` | `number` | yes | Maximum running instances that can be taken offline during update. |

### `node_groups{}.instance_template`

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

### `node_groups{}.instance_template.boot_disk`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `size` | `number` | yes | Boot disk size in GB. |
| `type` | `string` | yes | Boot disk type. |

### `node_groups{}.instance_template.container_network`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `pod_mtu` | `number` | no | MTU for pods. |

### `node_groups{}.instance_template.container_runtime`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `type` | `string` | yes | Container runtime type. |

### `node_groups{}.instance_template.gpu_settings`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `gpu_cluster_id` | `string` | no | GPU cluster ID. |
| `gpu_environment` | `string` | no | GPU environment. |

### `node_groups{}.instance_template.network_interface[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `ipv4` | `bool` | no | Allocate an IPv4 address. |
| `ipv6` | `bool` | no | Allocate an IPv6 address. |
| `nat` | `bool` | no | Allocate a public NAT address. |
| `security_group_ids` | `set(string)` | no | Security groups for the interface. |
| `subnet_ids` | `set(string)` | yes | Subnet IDs for the interface. |
| `ipv4_dns_records` | `list(object)` | no | IPv4 DNS records to create. |
| `ipv6_dns_records` | `list(object)` | no | IPv6 DNS records to create. |

### `node_groups{}.instance_template.network_interface[].ipv4_dns_records[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `dns_zone_id` | `string` | no | DNS zone ID. |
| `fqdn` | `string` | yes | DNS record FQDN. |
| `ptr` | `bool` | no | Whether to create a PTR record. |
| `ttl` | `number` | no | TTL for the DNS record. |

### `node_groups{}.instance_template.network_interface[].ipv6_dns_records[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `dns_zone_id` | `string` | no | DNS zone ID. |
| `fqdn` | `string` | yes | DNS record FQDN. |
| `ptr` | `bool` | no | Whether to create a PTR record. |
| `ttl` | `number` | no | TTL for the DNS record. |

### `node_groups{}.instance_template.placement_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `placement_group_id` | `string` | yes | Placement group ID for the instances. |

### `node_groups{}.instance_template.resources`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `core_fraction` | `number` | no | Baseline core performance as a percent. |
| `cores` | `number` | no | Number of CPU cores. |
| `gpus` | `number` | no | Number of GPUs. |
| `memory` | `number` | no | Memory size. |

### `node_groups{}.instance_template.scheduling_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `preemptible` | `bool` | no | Whether the instances are preemptible. |

### `node_groups{}.maintenance_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `auto_repair` | `bool` | no | Whether the node group can be repaired automatically. |
| `auto_upgrade` | `bool` | no | Whether the node group can be upgraded automatically. |
| `maintenance_window` | `list(object)` | no | Allowed maintenance windows. |

### `node_groups{}.maintenance_policy.maintenance_window[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `day` | `string` | no | Day of week for maintenance. |
| `duration` | `string` | yes | Duration of maintenance from start time. |
| `start_time` | `string` | yes | Start time of maintenance window. |

### `node_groups{}.scale_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `auto_scale` | `object` | no | Autoscaling configuration. |
| `fixed_scale` | `object` | no | Fixed-size scaling configuration. |

### `node_groups{}.scale_policy.auto_scale`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `initial` | `number` | yes | Initial node count. |
| `max` | `number` | yes | Maximum node count. |
| `min` | `number` | yes | Minimum node count. |

### `node_groups{}.scale_policy.fixed_scale`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `size` | `number` | yes | Fixed node count. |

### `node_groups{}.workload_identity_federation`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enabled` | `bool` | yes | Whether Workload Identity Federation is enabled for the node group. |

## Outputs

| Name | Description |
|------|-------------|
| `cluster` | The Kubernetes cluster resource. |
| `node_groups` | The Kubernetes node group resources keyed by node group name. |
