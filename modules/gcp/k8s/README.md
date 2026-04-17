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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_id` | GCP Project ID | `string` | n/a | yes |
| `name` | The name of the cluster | `string` | n/a | yes |
| `location` | The location (region or zone) for the cluster | `string` | n/a | yes |
| `node_locations` | The list of zones in which the cluster's nodes are located | `list(string)` | `[]` | no |
| `network` | The name or self_link of the Google Compute Engine network to which the cluster is connected | `string` | `null` | no |
| `subnetwork` | The name or self_link of the Google Compute Engine subnetwork to which the cluster is connected | `string` | `null` | no |
| `min_master_version` | The minimum version of the master | `string` | `null` | no |
| `description` | Description of the cluster | `string` | `null` | no |
| `deletion_protection` | Whether or not to allow Terraform to destroy the cluster. | `bool` | `true` | no |
| `resource_labels` | The GCE resource labels (a map of key/value pairs) to be applied to the cluster | `map(string)` | `null` | no |
| `networking_mode` | Determines whether alias IP or routes will be used for pod IPs in the cluster | `string` | `"VPC_NATIVE"` | no |
| `remove_default_node_pool` | deletes the default node pool upon cluster creation | `bool` | `true` | no |
| `ip_allocation_policy` | Configuration of cluster IP allocation | `object` | n/a | yes |
| `private_cluster_config` | Configuration for private clusters | `object` | `{}` | no |
| `master_authorized_networks_config` | Configuration for master authorized networks | `object` | `null` | no |
| `release_channel` | Configuration for release channels | `string` | `"STABLE"` | no |
| `workload_identity_config_pool` | Configuration for workload identity | `string` | `null` | no |
| `addons_config` | Configuration for GKE addons | `object` | `{}` | no |
| `logging_config_enable_components` | Configuration for cluster logging | `list(string)` | `["SYSTEM_COMPONENTS", "WORKLOADS"]` | no |
| `monitoring_config` | Configuration for cluster monitoring | `object` | `{}` | no |
| `maintenance_policy` | Configuration for maintenance policy | `object` | `null` | no |
| `network_policy` | Configuration for network policy | `object` | `null` | no |
| `database_encryption` | Configuration for database encryption | `object` | `{}` | no |
| `binary_authorization_evaluation_mode` | Configuration for binary authorization | `string` | `"DISABLED"` | no |
| `cluster_autoscaling` | Configuration for cluster autoscaling | `object` | `null` | no |
| `master_auth_issue_client_certificate` | Configuration for master authentication | `bool` | `false` | no |
| `authenticator_groups_config_security_group` | Configuration for RBAC group-based authentication | `string` | `null` | no |
| `confidential_nodes` | Configuration for confidential nodes | `object` | `null` | no |
| `cost_management_config_enabled` | Configuration for cost management | `bool` | `null` | no |
| `enable_shielded_nodes` | Enable Shielded Nodes features on all nodes in this cluster | `bool` | `false` | no |
| `enable_tpu` | value | `bool` | `false` | no |
| `initial_node_count` | The number of nodes to create in this cluster's default node pool | `number` | `0` | no |
| `enable_intranode_visibility` | Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network | `bool` | `false` | no |
| `vertical_pod_autoscaling_enabled` | Configuration for vertical pod autoscaling | `bool` | `true` | no |
| `default_snat_status_enabled` | Configuration for default SNAT status | `bool` | `true` | no |
| `dns_config` | Configuration for cluster DNS | `object` | `null` | no |
| `gateway_api_config_channel` | Configuration for gateway API | `string` | `null` | no |
| `identity_service_config_enabled` | Configuration for identity service | `bool` | `false` | no |
| `control_plane_endpoints_config` | Configuration for control plane endpoints | `object` | `{}` | no |
| `timeouts` | This resource provides the following Timeouts configuration options | `object` | `{}` | no |
| `node_pools` | A map of node pools to create | `map(object)` | n/a | yes |

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

### `node_pools`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | no | The name of the node pool. |
| `name_prefix` | `string` | no | Creates a unique name for the node pool beginning with the specified prefix. |
| `node_count` | `number` | no | Number of nodes per zone. |
| `max_pods_per_node` | `number` | no | The maximum number of pods per node in this node pool. |
| `autoscaling` | `object` | no | Configuration for node pool autoscaling. |
| `management` | `object` | no | Configuration for node pool management. |
| `node_config` | `object` | yes | Configuration for node pool nodes. |
| `upgrade_settings` | `object` | no | Configuration for node pool upgrade settings. |
| `queued_provisioning_enabled` | `bool` | no | Configuration for queued provisioning. |
| `network_config` | `object` | no | Configuration for node pool networking. |

### `node_pools{}.autoscaling`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `min_node_count` | `number` | no | Minimum number of nodes per zone. |
| `max_node_count` | `number` | no | Maximum number of nodes per zone. |
| `total_min_node_count` | `number` | no | Total minimum number of nodes in the NodePool. |
| `total_max_node_count` | `number` | no | Total maximum number of nodes in the NodePool. |
| `location_policy` | `string` | no | Location policy used when scaling up a nodepool. |

### `node_pools{}.management`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `auto_repair` | `bool` | no | Specifies whether the node auto-repair is enabled. |
| `auto_upgrade` | `bool` | no | Specifies whether node auto-upgrade is enabled. |

### `node_pools{}.node_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `machine_type` | `string` | no | The name of a Google Compute Engine machine type. |
| `service_account` | `string` | no | The Google Cloud Platform Service Account to be used by the node VMs. |
| `oauth_scopes` | `list(string)` | no | The set of Google API scopes to be made available on all of the node VMs. |
| `disk_size_gb` | `number` | no | Size of the disk attached to each node. |
| `disk_type` | `string` | no | Type of the disk attached to each node. |
| `image_type` | `string` | no | The image type to use for this node. |
| `labels` | `map(string)` | no | The map of Kubernetes labels (key/value pairs) to be applied to each node. |
| `metadata` | `map(string)` | no | The metadata key/value pairs assigned to instances in the cluster. |
| `tags` | `list(string)` | no | The list of instance tags applied to all nodes. |
| `preemptible` | `bool` | no | Whether or not the underlying node VMs are preemptible. |
| `spot` | `bool` | no | Whether the nodes are created as spot VM instances. |
| `local_ssd_count` | `number` | no | The amount of local SSD disks that will be attached to each node. |
| `taint` | `list(object)` | no | List of Kubernetes taints to be applied to each node. |
| `workload_metadata_config` | `object` | no | Metadata configuration to expose to workloads on the node pool. |
| `shielded_instance_config` | `object` | no | Shielded Instance options. |
| `kubelet_config` | `object` | no | Node kubelet configs. |
| `enable_confidential_storage` | `bool` | no | Whether confidential storage is enabled. |
| `flex_start` | `bool` | no | Node flex start configuration. |
| `logging_variant` | `string` | no | Type of logging agent that is used as the default value for node pools in the cluster. |
| `resource_manager_tags` | `map(string)` | no | A map of resource manager tags. |
| `storage_pools` | `list(string)` | no | The list of Storage Pools where boot disks are provisioned. |

### `node_pools{}.node_config.taint[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `key` | `string` | yes | Key for taint. |
| `value` | `string` | yes | Value for taint. |
| `effect` | `string` | yes | Effect for taint. |

### `node_pools{}.node_config.workload_metadata_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `mode` | `string` | no | Mode is the configuration for how to expose metadata to workloads running on the node. |

### `node_pools{}.node_config.shielded_instance_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `enable_secure_boot` | `bool` | no | Defines whether the instance has Secure Boot enabled. |
| `enable_integrity_monitoring` | `bool` | no | Defines whether the instance has integrity monitoring enabled. |

### `node_pools{}.node_config.kubelet_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `allowed_unsafe_sysctls` | `list(string)` | no | Allowed sysctls for nodes. |
| `container_log_max_files` | `number` | no | The maximum number of container log files that can be present for a container. |
| `image_gc_high_threshold_percent` | `number` | no | The percent of disk usage after which image garbage collection is always run. |
| `image_gc_low_threshold_percent` | `number` | no | The percent of disk usage before which image garbage collection is never run. |
| `insecure_kubelet_readonly_port_enabled` | `string` | no | Enable the insecure kubelet readonly port. |
| `cpu_cfs_quota` | `bool` | no | Enable CPU CFS quota enforcement for containers that specify CPU limits. |
| `pod_pids_limit` | `number` | no | Set the Pod PID limits. |

### `node_pools{}.upgrade_settings`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `max_surge` | `number` | no | The number of additional nodes that can be added to the node pool during an upgrade. |
| `max_unavailable` | `number` | no | The number of nodes that can be simultaneously unavailable during an upgrade. |
| `strategy` | `string` | no | The upgrade strategy to be used for upgrading the nodes. |

### `node_pools{}.network_config`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `create_pod_range` | `bool` | no | Whether to create a new range for pod IPs in this node pool. |
| `pod_range` | `string` | no | The ID of the secondary range for pod IPs. |
| `pod_ipv4_cidr_block` | `string` | no | The IP address range for pod IPs in this node pool. |
| `enable_private_nodes` | `bool` | no | Whether nodes have internal IP addresses only. |

## Outputs

| Name | Description |
|------|-------------|
| `cluster` | The Kubernetes cluster resource. |
| `node_pools` | The Kubernetes node pools resources keyed by node pool name. |
