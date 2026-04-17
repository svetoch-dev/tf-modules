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

| Name | Description | Type | Default | Required | Example |
|------|-------------|------|---------|:--------:|---------|
| `project_id` | The project ID to host the cluster in | `string` | n/a | yes | "my-project-id" |
| `name` | The name of the cluster | `string` | n/a | yes | "my-cluster" |
| `location` | The location (region or zone) for the cluster | `string` | n/a | yes | "us-central1" |
| `node_locations` | The list of zones in which the cluster's nodes are located | `list(string)` | `[]` | no | ["us-central1-a"] |
| `network` | The VPC network name or self_link | `string` | `null` | no | "default" |
| `subnetwork` | The VPC subnetwork name or self_link | `string` | `null` | no | "default" |
| `min_master_version` | The minimum version of the master | `string` | `null` | no | "1.27.3-gke.100" |
| `description` | Description of the cluster | `string` | `null` | no | "Production GKE cluster" |
| `deletion_protection` | Whether or not to allow Terraform to destroy the cluster | `bool` | `true` | no | true |
| `resource_labels` | GCE resource labels to be applied to the cluster | `map(string)` | `null` | no | {"env": "prod"} |
| `networking_mode` | Determines whether alias IP or routes will be used | `string` | `"VPC_NATIVE"` | no | "VPC_NATIVE" |
| `remove_default_node_pool` | Deletes the default node pool upon cluster creation | `bool` | `true` | no | true |
| `ip_allocation_policy` | Configuration of cluster IP allocation | `object` | n/a | yes | { cluster_secondary_range_name = "pods" } |
| `private_cluster_config` | Configuration for private clusters | `object` | `{}` | no | { enable_private_nodes = true } |
| `master_authorized_networks_config` | Configuration for master authorized networks | `object` | `null` | no | { cidr_blocks = [{ cidr_block = "0.0.0.0/0" }] } |
| `release_channel` | Configuration for release channels | `string` | `"STABLE"` | no | "REGULAR" |
| `workload_identity_config_pool` | Configuration for workload identity | `string` | `null` | no | "my-project-id.svc.id.goog" |
| `addons_config` | Configuration for GKE addons | `object` | `{}` | no | { http_load_balancing_enabled = true } |
| `logging_config_enable_components` | Configuration for cluster logging components | `list(string)` | `["SYSTEM_COMPONENTS", "WORKLOADS"]` | no | ["SYSTEM_COMPONENTS"] |
| `monitoring_config` | Configuration for cluster monitoring | `object` | `{}` | no | { enable_components = ["SYSTEM_COMPONENTS"] } |
| `maintenance_policy` | Configuration for maintenance policy | `object` | `null` | no | {} |
| `network_policy` | Configuration for network policy | `object` | `null` | no | { enabled = true } |
| `database_encryption` | Configuration for database encryption | `object` | `{}` | no | { state = "ENCRYPTED" } |
| `binary_authorization_evaluation_mode` | Configuration for binary authorization | `string` | `"DISABLED"` | no | "PROJECT_SINGLETON_POLICY_ENFORCE" |
| `cluster_autoscaling` | Configuration for cluster autoscaling | `object` | `null` | no | { enabled = true } |
| `master_auth_issue_client_certificate` | Whether to issue a client certificate for master auth | `bool` | `false` | no | false |
| `authenticator_groups_config_security_group` | Configuration for RBAC group-based authentication | `string` | `null` | no | "gke-security-groups@domain.com" |
| `confidential_nodes` | Configuration for confidential nodes | `object` | `null` | no | { enabled = true } |
| `cost_management_config_enabled` | Configuration for cost management | `bool` | `null` | no | true |
| `enable_shielded_nodes` | Enable Shielded Nodes features | `bool` | `false` | no | true |
| `enable_tpu` | Enable TPU for the cluster | `bool` | `false` | no | false |
| `initial_node_count` | Initial node count in default pool | `number` | `0` | no | 1 |
| `enable_intranode_visibility` | Enable Intra-node visibility | `bool` | `false` | no | false |
| `vertical_pod_autoscaling_enabled` | Enable vertical pod autoscaling | `bool` | `true` | no | true |
| `default_snat_status_enabled` | Enable default SNAT status | `bool` | `true` | no | true |
| `dns_config` | Configuration for cluster DNS | `object` | `null` | no | { cluster_dns = "CLOUD_DNS" } |
| `gateway_api_config_channel` | Configuration for gateway API channel | `string` | `null` | no | "CHANNEL_STANDARD" |
| `identity_service_config_enabled` | Enable identity service | `bool` | `false` | no | true |
| `control_plane_endpoints_config` | Configuration for control plane endpoints | `object` | `{}` | no | { ip_endpoints_config_enabled = true } |
| `timeouts` | Timeouts configuration for cluster | `object` | `{}` | no | { create = "30m" } |

## Type Details

### `ip_allocation_policy`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `cluster_secondary_range_name` | `string` | no | The name of the existing secondary range in the cluster's subnetwork to use for pod IP addresses. | "pods" |
| `services_secondary_range_name` | `string` | no | The name of the existing secondary range in the cluster's subnetwork to use for service ClusterIPs. | "services" |
| `cluster_ipv4_cidr_block` | `string` | no | The IP address range for the cluster pod IPs. | "10.0.0.0/14" |
| `services_ipv4_cidr_block` | `string` | no | The IP address range of the services IPs in this cluster. | "10.4.0.0/19" |
| `stack_type` | `string` | no | The IP Stack type of the cluster. Choose between `IPV4` and `IPV4_IPV6`. | "IPV4" |

### `private_cluster_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `enable_private_nodes` | `bool` | no | Enables the private cluster feature, creating a private endpoint on the cluster. | true |
| `enable_private_endpoint` | `bool` | no | When true, the cluster's private endpoint is used as the cluster endpoint and access through the public endpoint is disabled. | false |
| `master_ipv4_cidr_block` | `string` | no | The IP range in CIDR notation to use for the hosted master network. | "172.16.0.0/28" |
| `master_global_access_config_enabled` | `bool` | no | Whether the cluster master is accessible globally or not. | true |

### `master_authorized_networks_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `cidr_blocks` | `list(object)` | no | External networks that can access the Kubernetes cluster master through HTTPS. | [] |

### `master_authorized_networks_config.cidr_blocks[]`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `cidr_block` | `string` | yes | External network that can access Kubernetes master through HTTPS. Must be specified in CIDR notation. | "10.0.0.0/16" |
| `display_name` | `string` | no | Field for users to identify CIDR blocks. | "Office VPN" |

### `addons_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `http_load_balancing_enabled` | `bool` | no | The status of the HTTP (L7) load balancing controller addon, which makes it easy to set up HTTP load balancers for services in a cluster. | true |
| `horizontal_pod_autoscaling_enabled` | `bool` | no | The status of the Horizontal Pod Autoscaling addon, which increases or decreases the number of replica pods a replication controller has based on the resource usage of the existing pods. | true |
| `network_policy_config_enabled` | `bool` | no | Whether we should enable the network policy addon for the master. | true |
| `config_connector_config_enabled` | `bool` | no | The status of the ConfigConnector addon. | false |
| `dns_cache_config_enabled` | `bool` | no | The status of the NodeLocal DNSCache addon. | true |
| `gce_persistent_disk_csi_driver_config_enabled` | `bool` | no | Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver. | true |
| `gcp_filestore_csi_driver_config_enabled` | `bool` | no | The status of the Filestore CSI driver addon, which allows the usage of filestore instance as volumes. | true |
| `gke_backup_agent_config_enabled` | `bool` | no | The status of the Backup for GKE Agent addon. | false |
| `gcs_fuse_csi_driver_config_enabled` | `bool` | no | The status of the Cloud Storage Fuse CSI driver addon. | true |
| `cloudrun_config` | `object` | no | The status of the CloudRun addon. | {} |

### `addons_config.cloudrun_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `enabled` | `bool` | no | The status of the CloudRun addon. | true |
| `load_balancer_type` | `string` | no | The load balancer type of CloudRun ingress service; `LOAD_BALANCER_TYPE_EXTERNAL` or `LOAD_BALANCER_TYPE_INTERNAL`. | "LOAD_BALANCER_TYPE_EXTERNAL" |

### `monitoring_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `enable_components` | `list(string)` | no | The GKE components exposing metrics. Supported values include `SYSTEM_COMPONENTS`, `APISERVER`, `SCHEDULER`, `CONTROLLER_MANAGER`, `STORAGE`, `HPA`, `POD`, `DAEMONSET`, `DEPLOYMENT`, `STATEFULSET`, `CADVISOR`, `KUBELET`. | ["SYSTEM_COMPONENTS"] |
| `managed_prometheus` | `object` | no | Configuration for Google Cloud Managed Service for Prometheus. | { enabled = true } |

### `monitoring_config.managed_prometheus`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `enabled` | `bool` | no | Whether or not the managed collection is enabled. | true |

### `maintenance_policy`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `recurring_window` | `object` | no | Time window specified for recurring maintenance operations. | { <br>start_time = "2023-01-01T00:00:00Z", <br>recurrence = "FREQ=WEEKLY;BYDAY=SA", <br>end_time = "2020-02-07T18:00:00Z" <br>} |
| `daily_maintenance_window` | `object` | no | Time window specified for daily maintenance operations. | { start_time = "00:00" } |

### `maintenance_policy.recurring_window`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `start_time` | `string` | yes | Required if a recurring window is defined. Time window specified for recurring maintenance operations in RFC3339 format. | "2023-01-01T00:00:00Z" |
| `end_time` | `string` | yes | Required if a recurring window is defined. Time window specified for recurring maintenance operations in RFC3339 format. | "2023-01-01T04:00:00Z" |
| `recurrence` | `string` | yes | Required if a recurring window is defined. An RFC5545 RRULE, specifying how this window recurs. | "FREQ=WEEKLY;BYDAY=SA,SU" |

### `maintenance_policy.daily_maintenance_window`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `start_time` | `string` | yes | Start time of the window. | "2023-01-01T00:00:00Z" |

### `network_policy`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `enabled` | `bool` | no | Whether network policy is enabled on the cluster. | true |
| `provider` | `string` | no | The selected network policy provider. | "CALICO" |

### `database_encryption`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `state` | `string` | no | `ENCRYPTED` or `DECRYPTED`. | "ENCRYPTED" |
| `key_name` | `string` | no | The key to use to encrypt/decrypt secrets. | "projects/my-project/locations/global/keyRings/my-ring/cryptoKeys/my-key" |

### `cluster_autoscaling`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `enabled` | `bool` | no | Whether node auto-provisioning is enabled. | true |
| `autoscaling_profile` | `string` | no | Configuration options for the Autoscaler. | "BALANCED" |
| `resource_limits` | `list(object)` | no | Global constraints for machine resources in the cluster. | [{ resource_type = "cpu", minimum = 1 }] |
| `auto_provisioning_defaults` | `object` | no | Contains defaults for a node pool created by NAP. | { service_account = "k8s-nodes@my-project.iam.gserviceaccount.com" } |
| `auto_provisioning_locations` | `list(string)` | no | Locations for auto-provisioning. | ["us-central1-a"] |

### `cluster_autoscaling.resource_limits[]`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `resource_type` | `string` | yes | The type of the resource. For example, `cpu` and `memory`. | "cpu" |
| `minimum` | `number` | no | Minimum amount of the resource in the cluster. | 1 |
| `maximum` | `number` | no | Maximum amount of the resource in the cluster. | 10 |

### `cluster_autoscaling.auto_provisioning_defaults`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `service_account` | `string` | no | The Google Cloud Platform Service Account to be used by the node VMs. | "k8s-nodes@my-project.iam.gserviceaccount.com" |
| `oauth_scopes` | `list(string)` | no | Scopes that are used by NAP when creating node pools. | ["https://www.googleapis.com/auth/cloud-platform"] |
| `management` | `object` | no | Specifies the node management options for NAP created node-pools. | { auto_repair = true } |

### `cluster_autoscaling.auto_provisioning_defaults.management`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `auto_repair` | `bool` | no | Specifies whether the node auto-repair is enabled for the node pool. | true |
| `auto_upgrade` | `bool` | no | Specifies whether node auto-upgrade is enabled for the node pool. | true |

### `confidential_nodes`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `enabled` | `bool` | yes | Whether Confidential Nodes feature is enabled. | true |

### `dns_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `cluster_dns` | `string` | no | Which in-cluster DNS provider should be used. | "CLOUD_DNS" |
| `cluster_dns_scope` | `string` | no | The scope of access to cluster DNS records. | "VPC_SCOPE" |
| `cluster_dns_domain` | `string` | no | The suffix used for all cluster service records. | "cluster.local" |

### `control_plane_endpoints_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `dns_endpoint_config` | `object` | no | Configuration for DNS endpoint config. | { allow_external_traffic = true } |
| `ip_endpoints_config_enabled` | `bool` | no | Controls whether endpoint IPs are enabled. | true |

### `control_plane_endpoints_config.dns_endpoint_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `allow_external_traffic` | `bool` | no | Controls whether external traffic is allowed to the control plane. | true |

### `timeouts`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `create` | `string` | no | Timeout for create operations. | "30m" |
| `delete` | `string` | no | Timeout for delete operations. | "30m" |
| `update` | `string` | no | Timeout for update operations. | "30m" |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The Kubernetes cluster resource (`google_container_cluster`). |
 cluster resource (`google_container_cluster`). |
--|
| `create` | `string` | no | Timeout for create operations. | "30m" |
| `delete` | `string` | no | Timeout for delete operations. | "30m" |
| `update` | `string` | no | Timeout for update operations. | "30m" |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The Kubernetes cluster resource (`google_container_cluster`). |
