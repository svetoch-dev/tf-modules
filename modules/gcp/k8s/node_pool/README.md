# Google Kubernetes Engine Node Pool Module

Creates a `google_container_node_pool` resource.

## Usage

```hcl
module "node_pool" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/gke/node_pool?ref=master"

  project_id = "my-gcp-project-id"
  cluster    = "example-cluster"
  location   = "us-central1"
  name       = "general-pool"

  node_count = 1

  autoscaling = {
    min_node_count = 1
    max_node_count = 5
  }

  node_config = {
    machine_type = "e2-standard-4"
    disk_size_gb = 100
    disk_type    = "pd-ssd"
    labels = {
      role = "general-workloads"
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| google | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_id` | The project ID to host the cluster in | `string` | n/a | yes |
| `cluster` | The name of the cluster | `string` | n/a | yes |
| `location` | The location (region or zone) for the cluster | `string` | n/a | yes |
| `name` | The name of the node pool | `string` | n/a | yes |
| `name_prefix` | Creates a unique name for the node pool beginning with the specified prefix. Conflicts with name | `string` | `null` | no |
| `node_locations` | The list of zones in which the cluster's nodes are located | `list(string)` | `[]` | no |
| `node_count` | Number of nodes per zone | `number` | `null` | no |
| `max_pods_per_node` | The maximum number of pods per node in this node pool | `number` | `null` | no |
| `autoscaling` | Configuration for node pool autoscaling | `object` | `{}` | no |
| `management` | Configuration for node pool management | `object` | `{ auto_repair = true, auto_upgrade = true }` | no |
| `node_config` | Configuration for node pool nodes | `object` | `{}` | no |
| `upgrade_settings` | Configuration for node pool upgrade settings | `object` | `{ max_surge = 1, max_unavailable = 0 }` | no |
| `placement_policy` | Configuration for node placement policy | `object` | `null` | no |
| `queued_provisioning` | Configuration for queued provisioning | `object` | `null` | no |
| `network_config` | Configuration for node pool networking | `object` | `{}` | no |
| `timeouts` | This resource provides the following Timeouts configuration options | `object` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `node_pool_name` | Name of the GKE node pool |
| `instance_group_urls` | List of instance group URLs created for this node pool |

## Type Details

Detailed nested block structures for inputs such as `node_config`, `autoscaling`, and `management` closely map to the properties available in the `google_container_node_pool` Terraform resource natively, as managed by their internal object types defined in this module.
