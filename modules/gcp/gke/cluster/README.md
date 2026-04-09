# Google Kubernetes Engine Cluster Module

Creates a `google_container_cluster` resource.

## Usage

```hcl
module "cluster" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/gke/cluster?ref=master"

  project_id = "my-gcp-project-id"
  name       = "example-cluster"
  location   = "us-central1"
  network    = "my-vpc"
  subnetwork = "my-subnet"

  private_cluster_config = {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  release_channel = {
    channel = "REGULAR"
  }

  workload_identity_config = {
    workload_pool = "my-gcp-project-id.svc.id.goog"
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
| `name` | The name of the cluster | `string` | n/a | yes |
| `location` | The location (region or zone) for the cluster | `string` | n/a | yes |
| `node_locations` | The list of zones in which the cluster's nodes are located | `list(string)` | `[]` | no |
| `network` | The name or self_link of the Google Compute Engine network to which the cluster is connected | `string` | `null` | no |
| `subnetwork` | The name or self_link of the Google Compute Engine subnetwork to which the cluster is connected | `string` | `null` | no |
| `min_master_version` | The minimum version of the master | `string` | `null` | no |
| `description` | Description of the cluster | `string` | `null` | no |
| `deletion_protection` | Whether or not to allow Terraform to destroy the cluster. | `bool` | `true` | no |
| `resource_labels` | The GCE resource labels (a map of key/value pairs) to be applied to the cluster | `map(string)` | `{}` | no |
| `networking_mode` | Determines whether alias IP or routes will be used for pod IPs in the cluster | `string` | `"VPC_NATIVE"` | no |
| `remove_default_node_pool` | deletes the default node pool upon cluster creation | `bool` | `true` | no |
| `ip_allocation_policy` | Configuration of cluster IP allocation | `object` | `{}` | no |
| `private_cluster_config` | Configuration for private clusters | `object` | `{}` | no |
| `master_authorized_networks_config` | Configuration for master authorized networks | `object` | `{}` | no |
| `release_channel` | Configuration for release channels | `object` | `{}` | no |
| `workload_identity_config` | Configuration for workload identity | `object` | `{}` | no |
| `addons_config` | Configuration for GKE addons | `object` | `{}` | no |
| `logging_config` | Configuration for cluster logging | `object` | `{}` | no |
| `monitoring_config` | Configuration for cluster monitoring | `object` | `{}` | no |
| `maintenance_policy` | Configuration for maintenance policy | `object` | `{}` | no |
| `network_policy` | Configuration for network policy | `object` | `{}` | no |
| `database_encryption` | Configuration for database encryption | `object` | `{}` | no |
| `binary_authorization` | Configuration for binary authorization | `object` | `{}` | no |
| `cluster_autoscaling` | Configuration for cluster autoscaling | `object` | `{}` | no |
| `master_auth` | Configuration for master authentication | `object` | `{}` | no |
| `authenticator_groups_config` | Configuration for RBAC group-based authentication | `object` | `null` | no |
| `confidential_nodes` | Configuration for confidential nodes | `object` | `null` | no |
| `cost_management_config` | Configuration for cost management | `object` | `null` | no |
| `enable_shielded_nodes` | Enable Shielded Nodes features on all nodes in this cluster | `bool` | `false` | no |
| `enable_tpu` | value | `bool` | `false` | no |
| `initial_node_count` | The number of nodes to create in this cluster's default node pool | `number` | `0` | no |
| `enable_intranode_visibility` | Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network | `bool` | `false` | no |
| `vertical_pod_autoscaling` | Configuration for vertical pod autoscaling | `object` | `null` | no |
| `default_snat_status` | Configuration for default SNAT status | `object` | `{}` | no |
| `dns_config` | Configuration for cluster DNS | `object` | `null` | no |
| `gateway_api_config` | Configuration for gateway API | `object` | `null` | no |
| `identity_service_config` | Configuration for identity service | `object` | `null` | no |
| `control_plane_endpoints_config` | Configuration for control plane endpoints | `object` | `{}` | no |
| `timeouts` | This resource provides the following Timeouts configuration options | `object` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_name` | Name of the GKE cluster |
| `endpoint` | Cluster endpoint |
| `ca_certificate` | Cluster CA certificate |

## Type Details

Detailed nested block structures for inputs such as `ip_allocation_policy`, `private_cluster_config`, `addons_config`, etc., follow standard `google_container_cluster` documentation mapping structure due to the use of optional variable attributes and defaults mapping 1:1 with the provider definitions.
