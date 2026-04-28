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
