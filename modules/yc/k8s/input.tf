variable "network_id" {
  description = "The ID of the VPC network where the Kubernetes cluster will be created."
  type        = string
}

variable "service_account_id" {
  description = "Service account used for provisioning Compute Cloud and VPC resources for the cluster."
  type        = string
}

variable "node_service_account_id" {
  description = "Service account used by worker nodes to access registries, logs, and metrics."
  type        = string
}

variable "name" {
  description = "The Kubernetes cluster name."
  type        = string
  default     = null
}

variable "description" {
  description = "The Kubernetes cluster description."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The folder where the Kubernetes cluster will be created."
  type        = string
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs assigned to the cluster."
  type        = map(string)
  default     = {}
}

variable "release_channel" {
  description = "Cluster release channel."
  type        = string
  default     = null
}

variable "network_policy_provider" {
  description = "Network policy provider for the cluster."
  type        = string
  default     = "CALICO"
}

variable "pod_ipv4_range" {
  description = "CIDR block for pod IP addresses."
  type        = string
  default     = null
}

variable "pod_ipv6_range" {
  description = "CIDR block for pod IPv6 addresses."
  type        = string
  default     = null
}

variable "service_ipv4_range" {
  description = "CIDR block for service IP addresses."
  type        = string
  default     = null
}

variable "service_ipv6_range" {
  description = "CIDR block for service IPv6 addresses."
  type        = string
  default     = null
}

variable "node_ipv4_cidr_mask_size" {
  description = "Mask size assigned to each node for pod networking."
  type        = number
  default     = null
}

variable "kms_provider" {
  description = "Cluster KMS provider configuration."
  type = object(
    {
      key_id = string
    }
  )
  default = null
}

variable "workload_identity_federation" {
  description = "Workload Identity Federation configuration."
  type = object(
    {
      enabled = bool
    }
  )
  default = null
}

variable "admins" {
  description = "List of service account IAM member strings. Must use Yandex Cloud IAM member format such as 'serviceAccount:<id>', 'userAccount:<login>', 'group:<id>' etc. Special prefixes 'serviceAccountName:', 'userAccountName:' are also allowed. In this case module will look up the ids of users or service accounts using data sources"
  type        = list(string)
  default     = []
}

variable "viewers" {
  description = "List of service account IAM member strings. Must use Yandex Cloud IAM member format such as 'serviceAccount:<id>', 'userAccount:<login>', 'group:<id>' etc. Special prefixes 'serviceAccountName:', 'userAccountName:' are also allowed. In this case module will look up the ids of users or service accounts using data sources"
  type        = list(string)
  default     = []
}

variable "editors" {
  description = "List of service account IAM member strings. Must use Yandex Cloud IAM member format such as 'serviceAccount:<id>', 'userAccount:<login>', 'group:<id>' etc. Special prefixes 'serviceAccountName:', 'userAccountName:' are also allowed. In this case module will look up the ids of users or service accounts using data sources"
  type        = list(string)
  default     = []
}

variable "default_security_groups" {
  description = "Enable default security groups"
  type        = bool
  default     = true
}

variable "master" {
  description = "Kubernetes master configuration."
  type = object(
    {
      etcd_cluster_size  = optional(number)
      public_ip          = optional(bool)
      security_group_ids = optional(set(string), [])
      version            = optional(string)
      maintenance_policy = optional(
        object(
          {
            auto_upgrade = optional(bool)
            maintenance_window = optional(
              list(
                object(
                  {
                    day        = optional(string)
                    duration   = string
                    start_time = string
                  }
                )
              ),
              []
            )
          }
        )
      )
      master_location = optional(
        list(
          object(
            {
              zone      = string
              subnet_id = string
            }
          )
        ),
        []
      )
      master_logging = optional(
        object(
          {
            audit_enabled              = optional(bool)
            cluster_autoscaler_enabled = optional(bool)
            enabled                    = optional(bool)
            events_enabled             = optional(bool)
            folder_id                  = optional(string)
            kube_apiserver_enabled     = optional(bool)
            log_group_id               = optional(string)
          }
        )
      )
      network_implementation = optional(
        object(
          {
            cilium = optional(
              object({})
            )
          }
        )
      )
      regional = optional(
        object(
          {
            region = string
            location = list(
              object(
                {
                  zone      = string
                  subnet_id = string
                }
              )
            )
          }
        )
      )
      scale_policy = optional(
        object(
          {
            auto_scale = optional(
              object(
                {
                  min_resource_preset_id = string
                }
              )
            )
          }
        )
      )
      zonal = optional(
        object(
          {
            subnet_id = optional(string)
            zone      = string
          }
        )
      )
    }
  )

  validation {
    condition = length(compact([
      var.master.zonal == null ? "" : "zonal",
      var.master.regional == null ? "" : "regional",
      length(var.master.master_location) == 0 ? "" : "master_location",
    ])) == 1
    error_message = "Exactly one of master.zonal, master.regional, or master.master_location must be set."
  }
}

variable "node_groups" {
  description = "Map of Kubernetes node groups to create in the cluster."
  type = map(
    object(
      {
        name                   = optional(string)
        description            = optional(string)
        version                = optional(string)
        labels                 = optional(map(string), {})
        node_labels            = optional(map(string), {})
        node_taints            = optional(list(string), [])
        allowed_unsafe_sysctls = optional(list(string), [])
        variables              = optional(map(string), {})
        allocation_policy = object(
          {
            location = list(
              object(
                {
                  zone      = string
                  subnet_id = optional(string)
                }
              )
            )
          }
        )
        deploy_policy = optional(
          object(
            {
              max_expansion   = number
              max_unavailable = number
            }
          )
        )
        instance_template = object(
          {
            labels                    = optional(map(string), {})
            metadata                  = optional(map(string), {})
            name                      = optional(string)
            nat                       = optional(bool)
            network_acceleration_type = optional(string)
            platform_id               = optional(string)
            reserved_instance_pool_id = optional(string)
            boot_disk = optional(
              object(
                {
                  size = number
                  type = string
                }
              )
            )
            container_network = optional(
              object(
                {
                  pod_mtu = optional(number)
                }
              )
            )
            container_runtime = optional(
              object(
                {
                  type = string
                }
              )
            )
            gpu_settings = optional(
              object(
                {
                  gpu_cluster_id  = optional(string)
                  gpu_environment = optional(string)
                }
              )
            )
            network_interface = optional(
              list(
                object(
                  {
                    ipv4               = optional(bool)
                    ipv6               = optional(bool)
                    nat                = optional(bool)
                    security_group_ids = optional(set(string), [])
                    subnet_ids         = set(string)
                    ipv4_dns_records = optional(
                      list(
                        object(
                          {
                            dns_zone_id = optional(string)
                            fqdn        = string
                            ptr         = optional(bool)
                            ttl         = optional(number)
                          }
                        )
                      ),
                      []
                    )
                    ipv6_dns_records = optional(
                      list(
                        object(
                          {
                            dns_zone_id = optional(string)
                            fqdn        = string
                            ptr         = optional(bool)
                            ttl         = optional(number)
                          }
                        )
                      ),
                      []
                    )
                  }
                )
              ),
              []
            )
            placement_policy = optional(
              object(
                {
                  placement_group_id = string
                }
              )
            )
            resources = optional(
              object(
                {
                  core_fraction = optional(number)
                  cores         = optional(number)
                  gpus          = optional(number)
                  memory        = optional(number)
                }
              )
            )
            scheduling_policy = optional(
              object(
                {
                  preemptible = optional(bool)
                }
              )
            )
          }
        )
        maintenance_policy = optional(
          object(
            {
              auto_repair  = optional(bool)
              auto_upgrade = optional(bool)
              maintenance_window = optional(
                list(
                  object(
                    {
                      day        = optional(string)
                      duration   = string
                      start_time = string
                    }
                  )
                ),
                []
              )
            }
          )
        )
        scale_policy = object(
          {
            auto_scale = optional(
              object(
                {
                  initial = number
                  max     = number
                  min     = number
                }
              )
            )
            fixed_scale = optional(
              object(
                {
                  size = number
                }
              )
            )
          }
        )
        workload_identity_federation = optional(
          object(
            {
              enabled = bool
            }
          )
        )
      }
    )
  )
  default = {}

  validation {
    condition = alltrue([
      for _, node_group in var.node_groups :
      (
        (node_group.scale_policy.auto_scale == null && node_group.scale_policy.fixed_scale != null) ||
        (node_group.scale_policy.auto_scale != null && node_group.scale_policy.fixed_scale == null)
      )
    ])
    error_message = "Each node group must set exactly one of scale_policy.auto_scale or scale_policy.fixed_scale."
  }
}
