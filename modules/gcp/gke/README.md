# Google Kubernetes Engine (GKE) Module

Creates one or more GKE clusters with zero or more node pools.

## Usage

```hcl
module "gke" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/gke?ref=master"

  project_id = "my-gcp-project-id"

  gke_clusters = {
    "example-cluster" = {
      location   = "us-central1"
      network    = "my-vpc"
      subnetwork = "my-subnet"
      
      release_channel = {
        channel = "REGULAR"
      }
      
      private_cluster_config = {
        enable_private_nodes    = true
        enable_private_endpoint = false
        master_ipv4_cidr_block  = "172.16.0.0/28"
      }
    }
  }

  node_pools = {
    "general" = {
      cluster  = "example-cluster"
      location = "us-central1"
      name     = "general-pool"
      
      node_config = {
        machine_type = "e2-standard-4"
        disk_size_gb = 100
        disk_type    = "pd-ssd"
      }
      
      autoscaling = {
        min_node_count = 1
        max_node_count = 5
      }
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
| `project_id` | GCP Project ID | `string` | n/a | yes |
| `gke_clusters` | A map of GKE clusters to create | `map(object)` | `{}` | no |
| `node_pools` | A map of node pools to create | `map(object)` | `{}` | no |

## Notes

- This module composes the `cluster` and `node_pool` submodules. Node pools automatically depend on the completion of their cluster's creation.
- Most nested objects within `gke_clusters` and `node_pools` use the `optional` keyword with default values to minimize required boilerplate.

## Type Details

### `gke_clusters`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `location` | `string` | yes | The location (region or zone) in which the cluster master will be created. |
| `node_locations` | `list(string)` | no | The list of zones in which the cluster's nodes are located. |
| `network` | `string` | no | The name or self_link of the Google Compute Engine network to which the cluster is connected. |
| `subnetwork` | `string` | no | The name or self_link of the Google Compute Engine subnetwork to which the cluster is connected. |
| `min_master_version` | `string` | no | The minimum version of the master. |
| `description` | `string` | no | Description of the cluster. |
| `deletion_protection` | `bool` | no | Whether or not to allow Terraform to destroy the cluster. |
| `resource_labels` | `map(string)` | no | The GCE resource labels (a map of key/value pairs) to be applied to the cluster. |
| `networking_mode` | `string` | no | Determines whether alias IPs or routes will be used for pod IPs in the cluster. |
| `ip_allocation_policy` | `object` | no | Configuration of cluster IP allocation for VPC-native clusters. |
| `private_cluster_config` | `object` | no | Configuration for private clusters, clusters with private nodes. |
| `master_authorized_networks_config` | `object` | no | The desired configuration options for master authorized networks. |
| `release_channel` | `object` | no | Configuration options for the Release channel feature. |
| `workload_identity_config` | `object` | no | Configuration for the use of Kubernetes Service Accounts in GCP IAM policies. |
| `addons_config` | `object` | no | The configuration for addons supported by GKE. |
| `logging_config` | `object` | no | Logging configuration for the cluster. |
| `monitoring_config` | `object` | no | Monitoring configuration for the cluster. |
| `maintenance_policy` | `object` | no | The maintenance policy to use for the cluster. |
| `network_policy` | `object` | no | Configuration options for the NetworkPolicy feature. |
| `database_encryption` | `object` | no | Application-layer Secrets Encryption settings. |
| `binary_authorization` | `object` | no | Configuration options for the Binary Authorization feature. |
| `cluster_autoscaling` | `object` | no | Per-cluster configuration of Node Auto-Provisioning with Cluster Autoscaler. |
| `master_auth` | `object` | no | The authentication information for accessing the Kubernetes master. |
| `authenticator_groups_config` | `object` | no | Configuration for the Google Groups for GKE feature. |
| `confidential_nodes` | `object` | no | Configuration for the confidential nodes feature. |
| `cost_management_config` | `object` | no | Configuration for the Cost Management feature. |
| `enable_shielded_nodes` | `bool` | no | Enable Shielded Nodes features on all nodes in this cluster. |
| `enable_tpu` | `bool` | no | Whether to enable Cloud TPU resources in this cluster. |
| `initial_node_count` | `number` | no | The number of nodes to create in this cluster's default node pool. |
| `enable_intranode_visibility` | `bool` | no | Whether Intra-node visibility is enabled for this cluster. |
| `vertical_pod_autoscaling` | `object` | no | Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it. |
| `default_snat_status` | `object` | no | Default SNAT status. |
| `dns_config` | `object` | no | Configuration for Cloud DNS for Kubernetes Engine. |
| `gateway_api_config` | `object` | no | Configuration for GKE Gateway API controller. |
| `identity_service_config` | `object` | no | Configuration for Identity Service. |
| `control_plane_endpoints_config` | `object` | no | Configuration for the Control Plane Endpoints. |
| `timeouts` | `object` | no | Timeouts for create, update, and delete operations. |

### `gke_clusters.ip_allocation_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `cluster_secondary_range_name` | `string` | no | The name of the existing secondary range in the cluster's subnetwork to use for pod IP addresses. |
| `services_secondary_range_name` | `string` | no | The name of the existing secondary range in the cluster's subnetwork to use for service ClusterIPs. |
| `cluster_ipv4_cidr_block` | `string` | no | The IP address range for the cluster pod IPs. |
| `services_ipv4_cidr_block` | `string` | no | The IP address range of the services IPs in this cluster. |
| `stack_type` | `string` | no | The IP Stack type of the cluster. |

### `gke_clusters.private_cluster_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enable_private_nodes` | `bool` | no | Enables the private cluster feature. |
| `enable_private_endpoint` | `bool` | no | When true, the cluster's private endpoint is used as the cluster endpoint and access through the public endpoint is disabled. |
| `master_ipv4_cidr_block` | `string` | no | The IP range in CIDR notation to use for the hosted master network. |
| `master_global_access_config` | `object` | no | Controls cluster master global access settings. |

### `gke_clusters.addons_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `http_load_balancing` | `object` | no | The status of the HTTP (L7) load balancing controller addon. |
| `horizontal_pod_autoscaling` | `object` | no | The status of the Horizontal Pod Autoscaling addon. |
| `network_policy_config` | `object` | no | Whether we should enable the network policy addon for the master. |
| `cloudrun_config` | `object` | no | The status of the CloudRun addon. |
| `config_connector_config` | `object` | no | The status of the ConfigConnector addon. |
| `dns_cache_config` | `object` | no | The status of the NodeLocal DNSCache addon. |
| `gce_persistent_disk_csi_driver_config` | `object` | no | Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver. |
| `gcp_filestore_csi_driver_config` | `object` | no | The status of the Filestore CSI driver addon. |
| `gke_backup_agent_config` | `object` | no | The status of the Backup for GKE agent addon. |
| `gcs_fuse_csi_driver_config` | `object` | no | The status of the GCS Fuse CSI driver addon. |

### `node_pools`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `cluster` | `string` | yes | The cluster to create the node pool for. |
| `location` | `string` | yes | The location (region or zone) in which the cluster resides. |
| `name` | `string` | yes | The name of the node pool. |
| `name_prefix` | `string` | no | Creates a unique name for the node pool beginning with the specified prefix. |
| `node_locations` | `list(string)` | no | The list of zones in which the node pool's nodes should be located. |
| `initial_node_count` | `number` | no | The initial number of nodes for the pool. |
| `node_count` | `number` | no | The number of nodes per instance group. |
| `max_pods_per_node` | `number` | no | The maximum number of pods per node in this node pool. |
| `autoscaling` | `object` | no | Configuration required by cluster autoscaler to adjust the size of the node pool to the current cluster usage. |
| `management` | `object` | no | Node management configuration, wherein auto-repair and auto-upgrade is configured. |
| `node_config` | `object` | no | Parameters used in creating the node pool's nodes. |
| `upgrade_settings` | `object` | no | Specify node upgrade settings to change how GKE upgrades nodes. |
| `placement_policy` | `object` | no | Specifies the node placement policy. |
| `queued_provisioning` | `object` | no | Specifies the configuration of queued provisioning. |
| `network_config` | `object` | no | The network configuration of the node pool. |
| `timeouts` | `object` | no | Timeouts for create, update, and delete operations. |

### `node_pools.autoscaling`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `min_node_count` | `number` | no | Minimum number of nodes per zone in the NodePool. |
| `max_node_count` | `number` | no | Maximum number of nodes per zone in the NodePool. |
| `total_min_node_count` | `number` | no | Total minimum number of nodes in the NodePool. |
| `total_max_node_count` | `number` | no | Total maximum number of nodes in the NodePool. |
| `location_policy` | `string` | no | Location policy used when scaling up a nodepool. |

### `node_pools.node_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `machine_type` | `string` | no | The name of a Google Compute Engine machine type. |
| `service_account` | `string` | no | The Google Cloud Platform Service Account to be used by the node VMs. |
| `oauth_scopes` | `list(string)` | no | The set of Google API scopes to be made available on all of the node VMs. |
| `disk_size_gb` | `number` | no | Size of the disk attached to each node, specified in GB. |
| `disk_type` | `string` | no | Type of the disk attached to each node (e.g. 'pd-standard', 'pd-ssd' or 'pd-balanced'). |
| `image_type` | `string` | no | The image type to use for this node. Note that for a given image type, the latest version of it will be used. |
| `labels` | `map(string)` | no | The map of Kubernetes labels (key/value pairs) to be applied to each node. |
| `metadata` | `map(string)` | no | The metadata key/value pairs assigned to instances in the cluster. |
| `tags` | `list(string)` | no | The list of instance tags applied to all nodes. |
| `preemptible` | `bool` | no | Whether the nodes are created as preemptible VM instances. |
| `spot` | `bool` | no | Whether the nodes are created as Spot VM instances. |
| `local_ssd_count` | `number` | no | The amount of local SSD disks that will be attached to each node. |
| `taint` | `list(object)` | no | List of Kubernetes taints to be applied to each node. |
| `workload_metadata_config` | `object` | no | The workload metadata configuration for this node. |
| `shielded_instance_config` | `object` | no | Shielded Instance options. |
| `kubelet_config` | `object` | no | Node kubelet configs. |
| `linux_node_config` | `object` | no | Parameters that can be configured on Linux nodes. |
| `gvnic` | `object` | no | Google Virtual NIC (gVNIC) is a virtual network interface. |
| `reservation_affinity` | `object` | no | The reservation affinity configuration for the node pool. |
| `enable_confidential_storage` | `bool` | no | Whether Confidential Storage is enabled for the node pool. |
| `flex_start` | `bool` | no | Whether flex_start is enabled for the node pool. |
| `logging_variant` | `string` | no | Type of logging agent that is used as the default value for node pools in the cluster. |
| `resource_manager_tags` | `map(string)` | no | A map of resource manager tags. Resource manager tag keys and values have the same definition as resource manager tags. |
| `storage_pools` | `list(string)` | no | The list of Storage Pools where boot disks are provisioned. |
