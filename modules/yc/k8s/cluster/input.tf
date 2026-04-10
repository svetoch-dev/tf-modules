variable "network_id" {
  description = "The ID of the VPC network where the Kubernetes cluster will be created."
  type        = string
}

variable "service_account_id" {
  description = "Service account ID used for provisioning Compute Cloud and VPC resources for the cluster. Set this or enable default_service_account."
  type        = string
  default     = null
}

variable "node_service_account_id" {
  description = "Service account ID used by worker nodes to access registries, logs, and metrics. Set this or enable default_node_service_account."
  type        = string
  default     = null
}

variable "default_service_account" {
  description = "Whether to create and use the default service account for the Kubernetes control plane."
  type        = bool
  default     = false

  validation {
    condition     = var.service_account_id != null || var.default_service_account == true
    error_message = "default_service_account must be true or var.service_account_id must be set"
  }

}

variable "default_node_service_account" {
  description = "Whether to create and use the default service account for Kubernetes worker nodes."
  type        = bool
  default     = false

  validation {
    condition     = var.node_service_account_id != null || var.default_node_service_account == true
    error_message = "default_node_service_account must be true or var.node_service_account_id must be set"
  }

}

variable "master" {
  description = "Kubernetes master configuration."
  type = object(
    {
      etcd_cluster_size  = optional(number)
      public_ip          = optional(bool)
      security_group_ids = optional(list(string), [])
      k8s_version        = optional(string)
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

variable "network_implementation" {
  description = "Cluster network implementation."
  type = object(
    {
      cilium = optional(
        object({})
      )
    }
  )
  default = null
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
  description = "Cluster Workload Identity Federation configuration."
  type = object(
    {
      enabled = bool
    }
  )
  default = null
}

variable "iam_roles" {
  description = "IAM roles to grant on the Kubernetes cluster. Member values may use standard Yandex Cloud IAM member formats"
  type = list(
    object(
      {
        role    = string
        members = list(string)
      }
    )
  )
  default = []
}
