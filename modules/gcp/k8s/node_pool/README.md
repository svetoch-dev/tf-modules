# GKE Node Pool Submodule

This submodule manages a GKE node pool resource (`google_container_node_pool`).

## Usage

```hcl
module "node_pool" {
  source     = "./node_pool"
  project_id = "my-gcp-project"
  cluster    = "my-cluster"
  location   = "europe-west1"
  name       = "main-pool"
  
  node_count = 1
  
  node_config = {
    machine_type    = "e2-medium"
    service_account = "k8s-nodes@my-gcp-project.iam.gserviceaccount.com"
    disk_size_gb    = 50
    spot            = true
  }

  autoscaling = {
    min_node_count = 1
    max_node_count = 5
  }

  network_config = {
    pod_range = "pods"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required | Example |
|------|-------------|------|---------|:--------:|---------|
| `project_id` | The project ID to host the cluster in | `string` | n/a | yes | "my-project-id" |
| `cluster` | The name of the cluster | `string` | n/a | yes | "my-cluster" |
| `location` | The location (region or zone) for the cluster | `string` | n/a | yes | "us-central1" |
| `name` | The name of the node pool | `string` | n/a | yes | "my-cluster" |
| `name_prefix` | Creates a unique name for the node pool beginning with the specified prefix. Conflicts with name | `string` | `null` | no | "main-pool-" |
| `node_locations` | The list of zones in which the cluster's nodes are located | `list(string)` | `[]` | no | ["us-central1-a"] |
| `node_count` | Number of nodes per zone | `number` | `null` | no | 1 |
| `max_pods_per_node` | The maximum number of pods per node in this node pool | `number` | `null` | no | 110 |
| `autoscaling` | Configuration for node pool autoscaling | `object` | `{}` | no | { min_node_count = 1, max_node_count = 5 } |
| `management` | Configuration for node pool management | `object` | `{}` | no | { auto_repair = true } |
| `node_config` | Configuration for node pool nodes | `object` | n/a | yes | { machine_type = "e2-medium" } |
| `upgrade_settings` | Configuration for node pool upgrade settings | `object` | `{}` | no | { max_surge = 1 } |
| `queued_provisioning_enabled` | Configuration for queued provisioning | `bool` | `null` | no | false |
| `network_config` | Configuration for node pool networking | `object` | `{}` | no | { pod_range = "pods" } |
| `timeouts` | This resource provides the following Timeouts configuration options | `object` | `{}` | no | { create = "30m" } |

## Type Details

### `autoscaling`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `min_node_count` | `number` | no | Minimum number of nodes per zone. | 1 |
| `max_node_count` | `number` | no | Maximum number of nodes per zone. | 1 |
| `total_min_node_count` | `number` | no | Total minimum number of nodes in the NodePool. | 1 |
| `total_max_node_count` | `number` | no | Total maximum number of nodes in the NodePool. | 1 |
| `location_policy` | `string` | no | Location policy used when scaling up a nodepool. | "example" |

### `management`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `auto_repair` | `bool` | no | Specifies whether the node auto-repair is enabled for the node pool. | true |
| `auto_upgrade` | `bool` | no | Specifies whether node auto-upgrade is enabled for the node pool. | true |

### `node_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `machine_type` | `string` | no | The name of a Google Compute Engine machine type. | "e2-medium" |
| `service_account` | `string` | yes | The Google Cloud Platform Service Account to be used by the node VMs. | "k8s-nodes@my-project.iam.gserviceaccount.com" |
| `oauth_scopes` | `list(string)` | no | The set of Google API scopes to be made available on all of the node VMs. | ["https://www.googleapis.com/auth/cloud-platform"] |
| `disk_size_gb` | `number` | no | Size of the disk attached to each node. | 50 |
| `disk_type` | `string` | no | Type of the disk attached to each node. | "pd-ssd" |
| `image_type` | `string` | no | The image type to use for this node. | "COS_CONTAINERD" |
| `labels` | `map(string)` | no | The map of Kubernetes labels (key/value pairs) to be applied to each node. | {"env": "prod"} |
| `metadata` | `map(string)` | no | The metadata key/value pairs assigned to instances in the cluster. | {"disable-legacy-endpoints": "true"} |
| `tags` | `list(string)` | no | The list of instance tags applied to all nodes. | ["gke-node"] |
| `preemptible` | `bool` | no | Whether or not the underlying node VMs are preemptible. | false |
| `spot` | `bool` | no | Whether the nodes are created as spot VM instances. | true |
| `local_ssd_count` | `number` | no | The amount of local SSD disks that will be attached to each node. | 0 |
| `taint` | `list(object)` | no | List of Kubernetes taints to be applied to each node. | [] |
| `workload_metadata_config` | `object` | no | Metadata configuration to expose to workloads on the node pool. | {} |
| `shielded_instance_config` | `object` | no | Shielded Instance options. | {} |
| `kubelet_config` | `object` | no | Node kubelet configs. | {} |
| `enable_confidential_storage` | `bool` | no | Whether confidential storage is enabled. | true |
| `flex_start` | `bool` | no | Node flex start configuration. | true |
| `logging_variant` | `string` | no | Type of logging agent that is used as the default value for node pools in the cluster. | "example" |
| `resource_manager_tags` | `map(string)` | no | A map of resource manager tags. | {} |
| `storage_pools` | `list(string)` | no | The list of Storage Pools where boot disks are provisioned. | [] |

### `node_config.taint[]`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `key` | `string` | yes | Key for taint. | "dedicated" |
| `value` | `string` | yes | Value for taint. | "experimental" |
| `effect` | `string` | yes | Effect for taint. | "NO_SCHEDULE" |

### `node_config.workload_metadata_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `mode` | `string` | no | Mode is the configuration for how to expose metadata to workloads running on the node. | "GKE_METADATA" |

### `node_config.shielded_instance_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `enable_secure_boot` | `bool` | no | Defines whether the instance has Secure Boot enabled. | true |
| `enable_integrity_monitoring` | `bool` | no | Defines whether the instance has integrity monitoring enabled. | true |

### `node_config.kubelet_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `allowed_unsafe_sysctls` | `list(string)` | no | Allowed sysctls for nodes. | ["net.core.somaxconn"] |
| `container_log_max_files` | `number` | no | The maximum number of container log files that can be present for a container. | 5 |
| `image_gc_high_threshold_percent` | `number` | no | The percent of disk usage after which image garbage collection is always run. | 85 |
| `image_gc_low_threshold_percent` | `number` | no | The percent of disk usage before which image garbage collection is never run. | 80 |
| `insecure_kubelet_readonly_port_enabled` | `string` | no | Enable the insecure kubelet readonly port. | "false" |
| `cpu_cfs_quota` | `bool` | no | Enable CPU CFS quota enforcement for containers that specify CPU limits. | true |
| `pod_pids_limit` | `number` | no | Set the Pod PID limits. | 1024 |

### `upgrade_settings`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `max_surge` | `number` | no | The number of additional nodes that can be added to the node pool during an upgrade. | 1 |
| `max_unavailable` | `number` | no | The number of nodes that can be simultaneously unavailable during an upgrade. | 0 |
| `strategy` | `string` | no | The upgrade strategy to be used for upgrading the nodes. | "SURGE" |

### `network_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `create_pod_range` | `bool` | no | Whether to create a new range for pod IPs in this node pool. | false |
| `pod_range` | `string` | no | The ID of the secondary range for pod IPs. | "pods" |
| `pod_ipv4_cidr_block` | `string` | no | The IP address range for pod IPs in this node pool. | "10.0.0.0/14" |
| `enable_private_nodes` | `bool` | no | Whether nodes have internal IP addresses only. | true |

### `timeouts`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `create` | `string` | no | Timeout for create operations. | "30m" |
| `delete` | `string` | no | Timeout for delete operations. | "30m" |
| `update` | `string` | no | Timeout for update operations. | "30m" |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The node pool resource (`google_container_node_pool`). |
