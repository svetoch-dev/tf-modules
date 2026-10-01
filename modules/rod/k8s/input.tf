variable "k8s_api" {
  description = "information that is used by k8s provider to connect to k8s api"
  type = object(
    {
      endpoint = string
      token    = string
      ca_cert  = string
    }
  )
}

variable "cloud_service_accounts" {
  description = "Cloud service accounts from the cloud module output, used for workload identity annotations"
  type        = any
  default     = {}
}
