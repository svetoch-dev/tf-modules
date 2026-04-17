# GKE Cluster Submodule

This submodule manages the core GKE cluster resource (`google_container_cluster`).

## Usage

```hcl
module "cluster" {
  source     = "./cluster"
  project_id = "my-gcp-project"
  name       = "my-cluster"
  location   = "europe-west1"
  
  network    = "projects/my-project/global/networks/main"
  subnetwork = "projects/my-project/regions/europe-west1/subnetworks/vms"
  
  ip_allocation_policy = {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_id` | The project ID to host the cluster in | `string` | n/a | yes |
| `name` | The name of the cluster | `string` | n/a | yes |
| `location` | The location (region or zone) for the cluster | `string` | n/a | yes |
| `node_locations` | The list of zones in which the cluster's nodes are located | `list(string)` | `[]` | no |
| `network` | The VPC network name or self_link | `string` | `null` | no |
| `subnetwork` | The VPC subnetwork name or self_link | `string` | `null` | no |
| `min_master_version` | The minimum version of the master | `string` | `null` | no |
| `description` | Description of the cluster | `string` | `null` | no |
| `deletion_protection` | Whether or not to allow Terraform to destroy the cluster | `bool` | `true` | no |
| `resource_labels` | GCE resource labels to be applied to the cluster | `map(string)` | `null` | no |
| `networking_mode` | Determines whether alias IP or routes will be used | `string` | `"VPC_NATIVE"` | no |
| `remove_default_node_pool` | Deletes the default node pool upon cluster creation | `bool` | `true` | no |
| `ip_allocation_policy` | Configuration of cluster IP allocation | `object` | n/a | yes |
| `private_cluster_config` | Configuration for private clusters | `object` | `{}` | no |
| `master_authorized_networks_config` | Configuration for master authorized networks | `object` | `null` | no |
| `release_channel` | Configuration for release channels | `string` | `"STABLE"` | no |
| `workload_identity_config_pool` | Configuration for workload identity | `string` | `null` | no |
| `addons_config` | Configuration for GKE addons | `object` | `{}` | no |
| `logging_config_enable_components` | Configuration for cluster logging components | `list(string)` | `["SYSTEM_COMPONENTS", "WORKLOADS"]` | no |
| `monitoring_config` | Configuration for cluster monitoring | `object` | `{}` | no |
| `maintenance_policy` | Configuration for maintenance policy | `object` | `null` | no |
| `network_policy` | Configuration for network policy | `object` | `null` | no |
| `database_encryption` | Configuration for database encryption | `object` | `{}` | no |
| `binary_authorization_evaluation_mode` | Configuration for binary authorization | `string` | `"DISABLED"` | no |
| `cluster_autoscaling` | Configuration for cluster autoscaling | `object` | `null` | no |
| `master_auth_issue_client_certificate` | Whether to issue a client certificate for master auth | `bool` | `false` | no |
| `authenticator_groups_config_security_group` | Configuration for RBAC group-based authentication | `string` | `null` | no |
| `confidential_nodes` | Configuration for confidential nodes | `object` | `null` | no |
| `cost_management_config_enabled` | Configuration for cost management | `bool` | `null` | no |
| `enable_shielded_nodes` | Enable Shielded Nodes features | `bool` | `false` | no |
| `enable_tpu` | Enable TPU for the cluster | `bool` | `false` | no |
| `initial_node_count` | Initial node count in default pool | `number` | `0` | no |
| `enable_intranode_visibility` | Enable Intra-node visibility | `bool` | `false` | no |
| `vertical_pod_autoscaling_enabled` | Enable vertical pod autoscaling | `bool` | `true` | no |
| `default_snat_status_enabled` | Enable default SNAT status | `bool` | `true` | no |
| `dns_config` | Configuration for cluster DNS | `object` | `null` | no |
| `gateway_api_config_channel` | Configuration for gateway API channel | `string` | `null` | no |
| `identity_service_config_enabled` | Enable identity service | `bool` | `false` | no |
| `control_plane_endpoints_config` | Configuration for control plane endpoints | `object` | `{}` | no |
| `timeouts` | Timeouts configuration for cluster | `object` | `{}` | no |

## Type Details

### `ip_allocation_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `cluster_secondary_range_name` | `string` | no | The name of the existing secondary range in the cluster's subnetwork to use for pod IP addresses. |
| `services_secondary_range_name` | `string` | no | The name of the existing secondary range in the cluster's subnetwork to use for service ClusterIPs. |
| `cluster_ipv4_cidr_block` | `string` | no | The IP address range for the cluster pod IPs. |
| `services_ipv4_cidr_block` | `string` | no | The IP address range of the services IPs in this cluster. |
| `stack_type` | `string` | no | The IP Stack type of the cluster. Choose between `IPV4` and `IPV4_IPV6`. |

### `private_cluster_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enable_private_nodes` | `bool` | no | Enables the private cluster feature, creating a private endpoint on the cluster. |
| `enable_private_endpoint` | `bool` | no | When true, the cluster's private endpoint is used as the cluster endpoint and access through the public endpoint is disabled. |
| `master_ipv4_cidr_block` | `string` | no | The IP range in CIDR notation to use for the hosted master network. |
| `master_global_access_config_enabled` | `bool` | no | Whether the cluster master is accessible globally or not. |

### `master_authorized_networks_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `cidr_blocks` | `list(object)` | no | External networks that can access the Kubernetes cluster master through HTTPS. |

### `master_authorized_networks_config.cidr_blocks[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `cidr_block` | `string` | yes | External network that can access Kubernetes master through HTTPS. Must be specified in CIDR notation. |
| `display_name` | `string` | no | Field for users to identify CIDR blocks. |

### `addons_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `http_load_balancing_enabled` | `bool` | no | The status of the HTTP (L7) load balancing controller addon, which makes it easy to set up HTTP load balancers for services in a cluster. |
| `horizontal_pod_autoscaling_enabled` | `bool` | no | The status of the Horizontal Pod Autoscaling addon, which increases or decreases the number of replica pods a replication controller has based on the resource usage of the existing pods. |
| `network_policy_config_enabled` | `bool` | no | Whether we should enable the network policy addon for the master. |
| `config_connector_config_enabled` | `bool` | no | The status of the ConfigConnector addon. |
| `dns_cache_config_enabled` | `bool` | no | The status of the NodeLocal DNSCache addon. |
| `gce_persistent_disk_csi_driver_config_enabled` | `bool` | no | Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver. |
| `gcp_filestore_csi_driver_config_enabled` | `bool` | no | The status of the Filestore CSI driver addon, which allows the usage of filestore instance as volumes. |
| `gke_backup_agent_config_enabled` | `bool` | no | The status of the Backup for GKE Agent addon. |
| `gcs_fuse_csi_driver_config_enabled` | `bool` | no | The status of the Cloud Storage Fuse CSI driver addon. |
| `cloudrun_config` | `object` | no | The status of the CloudRun addon. |

### `addons_config.cloudrun_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enabled` | `bool` | no | The status of the CloudRun addon. |
| `load_balancer_type` | `string` | no | The load balancer type of CloudRun ingress service; `LOAD_BALANCER_TYPE_EXTERNAL` or `LOAD_BALANCER_TYPE_INTERNAL`. |

### `monitoring_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enable_components` | `list(string)` | no | The GKE components exposing metrics. Supported values include `SYSTEM_COMPONENTS`, `APISERVER`, `SCHEDULER`, `CONTROLLER_MANAGER`, `STORAGE`, `HPA`, `POD`, `DAEMONSET`, `DEPLOYMENT`, `STATEFULSET`, `CADVISOR`, `KUBELET`. |
| `managed_prometheus` | `object` | no | Configuration for Google Cloud Managed Service for Prometheus. |

### `monitoring_config.managed_prometheus`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enabled` | `bool` | no | Whether or not the managed collection is enabled. |

### `maintenance_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `recurring_window` | `object` | no | Time window specified for recurring maintenance operations. |
| `daily_maintenance_window` | `object` | no | Time window specified for daily maintenance operations. |

### `maintenance_policy.recurring_window`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `start_time` | `string` | yes | Time window specified for recurring maintenance operations in RFC3339 format. |
| `end_time` | `string` | yes | Time window specified for recurring maintenance operations in RFC3339 format. |
| `recurrence` | `string` | yes | An RFC5545 RRULE, specifying how this window recurs. |

### `maintenance_policy.daily_maintenance_window`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `start_time` | `string` | yes | Start time of the window. |

### `network_policy`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enabled` | `bool` | no | Whether network policy is enabled on the cluster. |
| `provider` | `string` | no | The selected network policy provider. |

### `database_encryption`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `state` | `string` | no | `ENCRYPTED` or `DECRYPTED`. |
| `key_name` | `string` | no | The key to use to encrypt/decrypt secrets. |

### `cluster_autoscaling`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enabled` | `bool` | no | Whether node auto-provisioning is enabled. |
| `autoscaling_profile` | `string` | no | Configuration options for the Autoscaler. |
| `resource_limits` | `list(object)` | no | Global constraints for machine resources in the cluster. |
| `auto_provisioning_defaults` | `object` | no | Contains defaults for a node pool created by NAP. |
| `auto_provisioning_locations` | `list(string)` | no | Locations for auto-provisioning. |

### `cluster_autoscaling.resource_limits[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `resource_type` | `string` | yes | The type of the resource. For example, `cpu` and `memory`. |
| `minimum` | `number` | no | Minimum amount of the resource in the cluster. |
| `maximum` | `number` | no | Maximum amount of the resource in the cluster. |

### `cluster_autoscaling.auto_provisioning_defaults`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `service_account` | `string` | no | The Google Cloud Platform Service Account to be used by the node VMs. |
| `oauth_scopes` | `list(string)` | no | Scopes that are used by NAP when creating node pools. |
| `management` | `object` | no | Specifies the node management options for NAP created node-pools. |

### `cluster_autoscaling.auto_provisioning_defaults.management`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `auto_repair` | `bool` | no | Specifies whether the node auto-repair is enabled for the node pool. |
| `auto_upgrade` | `bool` | no | Specifies whether node auto-upgrade is enabled for the node pool. |

### `confidential_nodes`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enabled` | `bool` | yes | Whether Confidential Nodes feature is enabled. |

### `dns_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `cluster_dns` | `string` | no | Which in-cluster DNS provider should be used. |
| `cluster_dns_scope` | `string` | no | The scope of access to cluster DNS records. |
| `cluster_dns_domain` | `string` | no | The suffix used for all cluster service records. |

### `control_plane_endpoints_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `dns_endpoint_config` | `object` | no | Configuration for DNS endpoint config. |
| `ip_endpoints_config_enabled` | `bool` | no | Controls whether endpoint IPs are enabled. |

### `control_plane_endpoints_config.dns_endpoint_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `allow_external_traffic` | `bool` | no | Controls whether external traffic is allowed to the control plane. |

### `timeouts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create` | `string` | no | Timeout for create operations. |
| `delete` | `string` | no | Timeout for delete operations. |
| `update` | `string` | no | Timeout for update operations. |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The Kubernetes cluster resource (`google_container_cluster`). |
