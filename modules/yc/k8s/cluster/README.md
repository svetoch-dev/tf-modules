# Yandex Kubernetes Cluster Module

Creates a `yandex_kubernetes_cluster` resource.

## Usage

```hcl
module "cluster" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/k8s/cluster?ref=master"

  name             = "example-cluster"
  description      = "General purpose cluster"
  folder_id        = "b1gxxxxxxxxxxxxxxx"
  network_id       = "enpxxxxxxxxxxxxxxx"
  release_channel  = "RAPID"
  network_policy_provider = "CALICO"

  labels = {
    env = "dev"
  }

  master = {
    k8s_version = "1.30"
    public_ip   = true
    zonal = {
      zone      = "ru-central1-a"
      subnet_id = "e9bxxxxxxxxxxxxxxx"
    }
    security_group_ids = ["enpzzzzzzzzzzzzzzz"]
    maintenance_policy = {
      auto_upgrade = true
      maintenance_window = [
        {
          start_time = "15:00"
          duration   = "3h"
        }
      ]
    }
    master_logging = {
      enabled                = true
      kube_apiserver_enabled = true
      events_enabled         = true
      audit_enabled          = true
    }
    scale_policy = {
      auto_scale = {
        min_resource_preset_id = "s-c4-m16"
      }
    }
  }

  workload_identity_federation = {
    enabled = true
  }

  iam_roles = [
    {
      role = "k8s.admin"
      members = [
        "group:aje0xxxxxxxxxxxxxx",
      ]
    },
    {
      role = "k8s.viewer"
      members = [
        "serviceAccountName:ci-runner",
      ]
    }
  ]
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
| `network_id` | The ID of the VPC network where the Kubernetes cluster will be created. | `string` | n/a | yes |
| `service_account_id` | Service account used for provisioning Compute Cloud and VPC resources for the cluster. If omitted, the module creates and uses a default service account. | `string` | `null` | no |
| `node_service_account_id` | Service account used by worker nodes to access registries, logs, and metrics. If omitted, the module creates and uses a default service account. | `string` | `null` | no |
| `master` | Kubernetes master configuration. | `object` | n/a | yes |
| `network_implementation` | Cluster network implementation. | `object` | `null` | no |
| `pod_ipv4_range` | CIDR block for pod IP addresses. | `string` | `null` | no |
| `pod_ipv6_range` | CIDR block for pod IPv6 addresses. | `string` | `null` | no |
| `description` | The Kubernetes cluster description. | `string` | `null` | no |
| `folder_id` | The folder where the Kubernetes cluster will be created. | `string` | `null` | no |
| `iam_roles` | IAM roles to grant for the Kubernetes cluster. | `list(object)` | n/a | yes |
| `kms_provider` | Cluster KMS provider configuration. | `object` | `null` | no |
| `labels` | A set of key/value label pairs assigned to the cluster. | `map(string)` | `{}` | no |
| `name` | The Kubernetes cluster name. | `string` | `null` | no |
| `network_policy_provider` | Network policy provider for the cluster. | `string` | `"CALICO"` | no |
| `node_ipv4_cidr_mask_size` | Mask size assigned to each node for pod networking. | `number` | `null` | no |
| `release_channel` | Cluster release channel. | `string` | `null` | no |
| `service_ipv4_range` | CIDR block for service IP addresses. | `string` | `null` | no |
| `service_ipv6_range` | CIDR block for service IPv6 addresses. | `string` | `null` | no |
| `workload_identity_federation` | Cluster Workload Identity Federation configuration. | `object` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The Kubernetes cluster resource. |

## Notes

- The module exposes all currently documented settable attributes of `yandex_kubernetes_cluster`.
- Exactly one of `master.zonal`, `master.regional`, or `master.master_location` must be set.
- Provider-computed attributes such as endpoints, CA certificate, health, status, log group ID, and version info are returned through the `this` output.
- If `service_account_id` or `node_service_account_id` is not provided, the module creates default `k8s-master` and `k8s-nodes` service accounts and uses them for the cluster.
- If IAM bindings for `service_account_id` or `node_service_account_id` are managed in the same configuration, add explicit `depends_on` on those IAM resources when using this module, matching the Yandex provider guidance.

## Type Details

### `master`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `etcd_cluster_size` | `number` | no | Number of etcd nodes for the master. |
| `public_ip` | `bool` | no | Whether the master endpoint is publicly accessible. |
| `security_group_ids` | `list(string)` | no | Security groups attached to the master. |
| `k8s_version` | `string` | no | Kubernetes version for the master. |
| `maintenance_policy` | `object` | no | Master maintenance policy configuration. |
| `master_location` | `list(object)` | no | Explicit master locations. |
| `master_logging` | `object` | no | Master logging configuration. |
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

### `network_implementation`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `cilium` | `object` | no | Enables the Cilium network implementation. |

### `network_implementation.cilium`

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

### `iam_roles[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `role` | `string` | yes | IAM role to grant. |
| `members` | `list(string)` | yes | Members that should receive the role. Standard Yandex Cloud IAM member formats are supported, along with `serviceAccountName:` and `userAccountName:` aliases resolved by the module. |

### `kms_provider`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `key_id` | `string` | yes | KMS key ID used for secrets encryption. |

### `workload_identity_federation`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enabled` | `bool` | yes | Whether Workload Identity Federation is enabled for the cluster. |
