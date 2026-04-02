variable "cluster_id" {
  description = "The ID of the Kubernetes cluster that this node group belongs to."
  type        = string
}

variable "name" {
  description = "The node group name."
  type        = string
  default     = null
}

variable "description" {
  description = "The node group description."
  type        = string
  default     = null
}

variable "k8s_version" {
  description = "Kubernetes version for the node group."
  type        = string
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs assigned to the node group resource."
  type        = map(string)
  default     = {}
}

variable "node_labels" {
  description = "A set of key/value label pairs assigned to all nodes in the node group."
  type        = map(string)
  default     = {}
}

variable "node_taints" {
  description = "A list of Kubernetes taints applied to all nodes in the node group."
  type = list(
    object(
      {
        key    = string
        value  = optional(string)
        effect = string
      }
    )
  )
  default = []
}

variable "allowed_unsafe_sysctls" {
  description = "A list of allowed unsafe sysctl parameters for this node group."
  type        = list(string)
  default     = []
}

variable "variables" {
  description = "Variables for templating as key/value pairs."
  type        = map(string)
  default     = {}
}

variable "allocation_policy" {
  description = "Subnets and zones that will be used by node group compute instances."
  type = object(
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
}

variable "deploy_policy" {
  description = "Deploy policy of the node group."
  type = object(
    {
      max_expansion   = number
      max_unavailable = number
    }
  )
  default = null
}

variable "instance_template" {
  description = "Template used to create compute instances in this Kubernetes node group."
  type = object(
    {
      labels                    = optional(map(string), {})
      metadata                  = optional(map(string), {})
      name                      = optional(string)
      nat                       = optional(bool)
      network_acceleration_type = optional(string)
      cpu_platform_id           = optional(string)
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
              security_group_ids = optional(list(string), [])
              subnet_ids         = optional(list(string), [])
              subnet_names       = optional(list(string), [])
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

  validation {
    condition = (
      alltrue(
        [
          for network_interface in var.instance_template.network_interface :
          network_interface.subnet_ids != [] || network_interface.subnet_names != []
        ]
      )
    )
    error_message = "instance_template.network_interface.subnet_ids or instance_template.network_interface.subnet_names should be set"
  }
}

variable "maintenance_policy" {
  description = "Maintenance policy for this Kubernetes node group."
  type = object(
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
  default = null
}

variable "scale_policy" {
  description = "Scale policy of the node group."
  type = object(
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

  validation {
    condition = (
      (var.scale_policy.auto_scale == null && var.scale_policy.fixed_scale != null) ||
      (var.scale_policy.auto_scale != null && var.scale_policy.fixed_scale == null)
    )
    error_message = "Exactly one of scale_policy.auto_scale or scale_policy.fixed_scale must be set."
  }
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
