# GKE Module

This module manages a Google Kubernetes Engine (GKE) cluster and its associated node pools. It serves as a wrapper around the `cluster` and `node_pool` submodules.

## Usage

```hcl
module "gke" {
  source     = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/k8s?ref=master"
  project_id = "my-gcp-project"
  name       = "main-cluster"
  location   = "europe-west1"
  
  network    = "projects/my-project/global/networks/main"
  subnetwork = "projects/my-project/regions/europe-west1/subnetworks/vms"
  
  ip_allocation_policy = {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config = {
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  master_authorized_networks_config = {
    cidr_blocks = [{
      cidr_block   = "0.0.0.0/0"
      display_name = "Allow all"
    }]
  }

  addons_config = {
    gce_persistent_disk_csi_driver_config_enabled = true
    gcs_fuse_csi_driver_config_enabled            = true
  }

  network_policy = {
    enabled = true
  }

  logging_config_enable_components = [
    "SYSTEM_COMPONENTS",
    "APISERVER",
    "CONTROLLER_MANAGER",
    "SCHEDULER",
  ]

  maintenance_policy = {
    recurring_window = {
      start_time = "2020-02-07T06:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SA"
      end_time   = "2020-02-07T18:00:00Z"
    }
  }

  resource_labels = {
    "env" = "prod"
  }

  node_pools = {
    main = {
      name = "main"
      node_config = {
        machine_type    = "t2d-standard-4"
        service_account = "k8s-nodes@my-gcp-project.iam.gserviceaccount.com"
        disk_size_gb    = 45
        labels = {
          main = "true"
        }
        spot = true
      }
      autoscaling = {
        min_node_count = 0
        max_node_count = 10
      }
      network_config = {
        pod_range = "pods"
      }
    },
    on_demand = {
      name = "on-demand"
      node_config = {
        machine_type    = "t2d-standard-4"
        service_account = "k8s-nodes@my-gcp-project.iam.gserviceaccount.com"
        disk_size_gb    = 45
        labels = {
          on-demand = "true"
        }
        taint = [
          {
            key    = "on-demand"
            value  = "true"
            effect = "NO_SCHEDULE"
          },
        ]
      }
      autoscaling = {
        min_node_count  = 0
        max_node_count  = 10
        location_policy = "BALANCED"
      }
      network_config = {
        pod_range = "pods"
      }
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required | Example |
|------|-------------|------|---------|:--------:|---------|
| `project_id` | GCP Project ID | `string` | n/a | yes | "my-project-id" |
| `name` | The name of the cluster | `string` | n/a | yes | "my-cluster" |
| `location` | The location (region or zone) for the cluster | `string` | n/a | yes | "us-central1" |
| `node_locations` | The list of zones in which the cluster's nodes are located | `list(string)` | `[]` | no | ["us-central1-a"] |
| `network` | The name or self_link of the Google Compute Engine network to which the cluster is connected | `string` | `null` | no | "default" |
| `subnetwork` | The name or self_link of the Google Compute Engine subnetwork to which the cluster is connected | `string` | `null` | no | "projects/my-project/regions/us-central1/subnetworks/default" |
| `min_master_version` | The minimum version of the master | `string` | `null` | no | "1.27.3-gke.100" |
| `description` | Description of the cluster | `string` | `null` | no | "Production GKE cluster" |
| `deletion_protection` | Whether or not to allow Terraform to destroy the cluster. | `bool` | `true` | no | true |
| `resource_labels` | The GCE resource labels (a map of key/value pairs) to be applied to the cluster | `map(string)` | `null` | no | {"env": "prod"} |
| `networking_mode` | Determines whether alias IP or routes will be used for pod IPs in the cluster. Accepted values: `VPC_NATIVE` or `ROUTES`. | `string` | `"VPC_NATIVE"` | no | "VPC_NATIVE" |
| `remove_default_node_pool` | deletes the default node pool upon cluster creation | `bool` | `true` | no | true |
| `ip_allocation_policy` | Configuration of cluster IP allocation. `cluster_secondary_range_name` conflicts with `cluster_ipv4_cidr_block`, and `services_secondary_range_name` conflicts with `services_ipv4_cidr_block`. You must provide either a range name (for existing secondary ranges) OR a CIDR block (for GKE to create them). | `object` | n/a | yes | { cluster_secondary_range_name = "pods" } |
| `private_cluster_config` | Configuration for private clusters | `object` | `{}` | no | { enable_private_nodes = true } |
| `master_authorized_networks_config` | Configuration for master authorized networks | `object` | `null` | no | { cidr_blocks = [{ cidr_block = "0.0.0.0/0" }] } |
| `release_channel` | Configuration for release channels. Accepted values: `UNSPECIFIED`, `RAPID`, `REGULAR`, `STABLE`. | `string` | `"STABLE"` | no | "STABLE" |
| `workload_identity_config_pool` | Configuration for workload identity | `string` | `null` | no | "my-project-id.svc.id.goog" |
| `addons_config` | Configuration for GKE addons | `object` | `{}` | no | { http_load_balancing_enabled = true } |
| `logging_config_enable_components` | Configuration for cluster logging | `list(string)` | `["SYSTEM_COMPONENTS", "WORKLOADS"]` | no | ["SYSTEM_COMPONENTS"] |
| `monitoring_config` | Configuration for cluster monitoring | `object` | `{}` | no | { enable_components = ["SYSTEM_COMPONENTS"] } |
| `maintenance_policy` | Configuration for maintenance policy (Optional) | `object` | `null` | no | {} |
| `network_policy` | Configuration for network policy | `object` | `null` | no | { enabled = true } |
| `database_encryption` | Configuration for database encryption | `object` | `{}` | no | { state = "ENCRYPTED" } |
| `binary_authorization_evaluation_mode` | Configuration for binary authorization. Accepted values: `DISABLED`, `PROJECT_SINGLETON_POLICY_ENFORCE`. | `string` | `"DISABLED"` | no | "PROJECT_SINGLETON_POLICY_ENFORCE" |
| `cluster_autoscaling` | Configuration for cluster autoscaling | `object` | `null` | no | { enabled = true } |
| `master_auth_issue_client_certificate` | Configuration for master authentication | `bool` | `false` | no | false |
| `authenticator_groups_config_security_group` | Configuration for RBAC group-based authentication | `string` | `null` | no | "gke-security-groups@domain.com" |
| `confidential_nodes` | Configuration for confidential nodes | `object` | `null` | no | { enabled = true } |
| `cost_management_config_enabled` | Configuration for cost management | `bool` | `null` | no | true |
| `enable_shielded_nodes` | Enable Shielded Nodes features on all nodes in this cluster | `bool` | `false` | no | true |
| `enable_tpu` | value | `bool` | `false` | no | false |
| `initial_node_count` | The number of nodes to create in this cluster's default node pool | `number` | `0` | no | 1 |
| `enable_intranode_visibility` | Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network | `bool` | `false` | no | false |
| `vertical_pod_autoscaling_enabled` | Configuration for vertical pod autoscaling | `bool` | `true` | no | true |
| `default_snat_status_enabled` | Configuration for default SNAT status | `bool` | `true` | no | true |
| `dns_config` | Configuration for cluster DNS | `object` | `null` | no | { cluster_dns = "CLOUD_DNS" } |
| `gateway_api_config_channel` | Configuration for gateway API | `string` | `null` | no | "CHANNEL_STANDARD" |
| `identity_service_config_enabled` | Configuration for identity service | `bool` | `false` | no | true |
| `control_plane_endpoints_config` | Configuration for control plane endpoints | `object` | `{}` | no | { ip_endpoints_config_enabled = true } |
| `timeouts` | This resource provides the following Timeouts configuration options | `object` | `{}` | no | { create = "30m" } |
| `node_pools` | A map of node pools to create | `map(object)` | n/a | yes | { main = { name = "main" } } |

## Notes

- This module composes the `cluster` and `node_pool` submodules and ensures node pools are created with an explicit dependency on the cluster.
- The default GKE node pool is deleted by default (`remove_default_node_pool = true`). Custom node pools must be defined via the `node_pools` variable.
- The `node_pools` automatically inherit the following properties from the root cluster configuration, ensuring they match the cluster:
  - `project_id`
  - `cluster` (inherits from `name`)
  - `location`
  - `node_locations`
  - `timeouts`
- **Service Account Requirement**: You must explicitly define `node_pools[*].node_config.service_account`. It is highly discouraged to rely on the default Compute Engine service account for node pools due to its overly broad permissions.
- **Workload Identity**: If `workload_identity_config_pool` is not provided, the module configures workload identity to use the default pool format: `<project_id>.svc.id.goog`.

## Type Details

### `ip_allocation_policy`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `cluster_secondary_range_name` | `string` | no | The name of the existing secondary range in the cluster's subnetwork to use for pod IP addresses. Conflicts with `cluster_ipv4_cidr_block`. | "pods" |
| `services_secondary_range_name` | `string` | no | The name of the existing secondary range in the cluster's subnetwork to use for service ClusterIPs. Conflicts with `services_ipv4_cidr_block`. | "services" |
| `cluster_ipv4_cidr_block` | `string` | no | The IP address range for the cluster pod IPs. Conflicts with `cluster_secondary_range_name`. | "10.0.0.0/14" |
| `services_ipv4_cidr_block` | `string` | no | The IP address range of the services IPs in this cluster. Conflicts with `services_secondary_range_name`. | "10.4.0.0/19" |
| `stack_type` | `string` | no | The IP Stack type of the cluster. Accepted values: `IPV4`, `IPV4_IPV6`. | "IPV4" |

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

### `node_pools`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `name` | `string` | no | The name of the node pool. | "my-cluster" |
| `name_prefix` | `string` | no | Creates a unique name for the node pool beginning with the specified prefix. | "main-pool-" |
| `node_count` | `number` | no | Number of nodes per zone. | 1 |
| `max_pods_per_node` | `number` | no | The maximum number of pods per node in this node pool. | 110 |
| `autoscaling` | `object` | no | Configuration for node pool autoscaling. | { min_node_count = 1, max_node_count = 5 } |
| `management` | `object` | no | Configuration for node pool management. | { auto_repair = true } |
| `node_config` | `object` | yes | Configuration for node pool nodes. | { machine_type = "e2-medium" } |
| `upgrade_settings` | `object` | no | Configuration for node pool upgrade settings. | { max_surge = 1 } |
| `queued_provisioning_enabled` | `bool` | no | Configuration for queued provisioning. | false |
| `network_config` | `object` | no | Configuration for node pool networking. | { pod_range = "pods" } |

### `node_pools{}.autoscaling`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `min_node_count` | `number` | no | Minimum number of nodes per zone. | 1 |
| `max_node_count` | `number` | no | Maximum number of nodes per zone. | 1 |
| `total_min_node_count` | `number` | no | Total minimum number of nodes in the NodePool. | 1 |
| `total_max_node_count` | `number` | no | Total maximum number of nodes in the NodePool. | 1 |
| `location_policy` | `string` | no | Location policy used when scaling up a nodepool. Accepted values: `BALANCED`, `ANY`. | "BALANCED" |

### `node_pools{}.management`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `auto_repair` | `bool` | no | Specifies whether the node auto-repair is enabled. | true |
| `auto_upgrade` | `bool` | no | Specifies whether node auto-upgrade is enabled. | true |

### `node_pools{}.node_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `machine_type` | `string` | no | The name of a Google Compute Engine machine type. | "e2-medium" |
| `service_account` | `string` | no | The Google Cloud Platform Service Account to be used by the node VMs. | "k8s-nodes@my-project.iam.gserviceaccount.com" |
| `oauth_scopes` | `list(string)` | no | The set of Google API scopes to be made available on all of the node VMs. | ["https://www.googleapis.com/auth/cloud-platform"] |
| `disk_size_gb` | `number` | no | Size of the disk attached to each node. | 50 |
| `disk_type` | `string` | no | Type of the disk attached to each node. Accepted values: `pd-standard`, `pd-ssd`, `pd-balanced`, `pd-extreme`. | "pd-ssd" |
| `image_type` | `string` | no | The image type to use for this node. Accepted values: `COS_CONTAINERD`, `UBUNTU_CONTAINERD`, `COS`, `UBUNTU`, `WINDOWS_LTSC_CONTAINERD`, `WINDOWS_SAC_CONTAINERD`. | "COS_CONTAINERD" |
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

### `node_pools{}.node_config.taint[]`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `key` | `string` | yes | Key for taint. | "dedicated" |
| `value` | `string` | yes | Value for taint. | "experimental" |
| `effect` | `string` | yes | Effect for taint. | "NO_SCHEDULE" |

### `node_pools{}.node_config.workload_metadata_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `mode` | `string` | no | Mode is the configuration for how to expose metadata to workloads running on the node. | "GKE_METADATA" |

### `node_pools{}.node_config.shielded_instance_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `enable_secure_boot` | `bool` | no | Defines whether the instance has Secure Boot enabled. | true |
| `enable_integrity_monitoring` | `bool` | no | Defines whether the instance has integrity monitoring enabled. | true |

### `node_pools{}.node_config.kubelet_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `allowed_unsafe_sysctls` | `list(string)` | no | Allowed sysctls for nodes. | ["net.core.somaxconn"] |
| `container_log_max_files` | `number` | no | The maximum number of container log files that can be present for a container. | 5 |
| `image_gc_high_threshold_percent` | `number` | no | The percent of disk usage after which image garbage collection is always run. | 85 |
| `image_gc_low_threshold_percent` | `number` | no | The percent of disk usage before which image garbage collection is never run. | 80 |
| `insecure_kubelet_readonly_port_enabled` | `string` | no | Enable the insecure kubelet readonly port. | "false" |
| `cpu_cfs_quota` | `bool` | no | Enable CPU CFS quota enforcement for containers that specify CPU limits. | true |
| `pod_pids_limit` | `number` | no | Set the Pod PID limits. | 1024 |

### `node_pools{}.upgrade_settings`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `max_surge` | `number` | no | The number of additional nodes that can be added to the node pool during an upgrade. | 1 |
| `max_unavailable` | `number` | no | The number of nodes that can be simultaneously unavailable during an upgrade. | 0 |
| `strategy` | `string` | no | The upgrade strategy to be used for upgrading the nodes. | "SURGE" |

### `node_pools{}.network_config`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `create_pod_range` | `bool` | no | Whether to create a new range for pod IPs in this node pool. | false |
| `pod_range` | `string` | no | The ID of the secondary range for pod IPs. | "pods" |
| `pod_ipv4_cidr_block` | `string` | no | The IP address range for pod IPs in this node pool. | "10.0.0.0/14" |
| `enable_private_nodes` | `bool` | no | Whether nodes have internal IP addresses only. | true |

## Outputs

| Name | Description |
|------|-------------|
| `cluster` | The Kubernetes cluster resource. |
| `node_pools` | The Kubernetes node pools resources keyed by node pool name. |
