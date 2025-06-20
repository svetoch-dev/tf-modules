variable "project" {
  description = "Project configuration"
  type = object({
    id     = string
    region = string
  })
}

variable "gcs" {
  description = "A list of gcs buckets more info - https://github.com/terraform-google-modules/terraform-google-cloud-storage"
  type        = any
  default     = {}
}

variable "activate_apis" {
  description = "What apis need to be activated in a gcp project"
  type        = list(string)
}

variable "gke_clusters" {
  description = "A list of gke clusters more info - https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/private-cluster"
  type        = any
  default     = {}
}

variable "networks" {
  description = "Networking configuration for this project"
  type        = any
  default     = {}
}

variable "iam" {
  description = "Gcp project iam definition more info in submodule  ./iam"
  type        = any
  default     = {}
}

variable "gars" {
  description = "A list of gar registries to create in this project"
  type        = any
  default     = {}
}

variable "gcrs" {
  description = "A list of gcr registries to create in this project"
  type        = any
  default     = {}
}

variable "dns_zones" {
  description = "A list of dns zones to create in this project"
  type        = any
  default     = {}
}

variable "cloudsql_postgres" {
  description = "A list of cloudsql postgres dbs more info"
  type        = any
  default     = {}
}

variable "redis_instances" {
  description = "A list of memorystore redis instances"
  type        = any
  default     = {}
}

variable "cloudrun_services" {
  description = "A list of cloudrun service instances"
  type        = any
  default     = {}
}

variable "application_lbs" {
  description = "A list of application loadbalancers"
  type        = any
  default     = {}
}

variable "kms_key_rings" {
  description = "A list of kms key rings"
  type        = any
  default     = {}
}

variable "cloud_tasks" {
  description = "A list of cloud tasks"
  type        = any
  default     = {}
}

variable "cloud_schedules" {
  description = "A list of cloud schedules"
  type        = any
  default     = {}
}

variable "firestores" {
  description = "A list of firestores"
  type        = any
  default     = {}
}

variable "vms" {
  description = "A list of virtual machines"
  type        = any
  default     = {}
}

variable "pubsubs" {
  description = "A list of pubsub messaging services to create in this project"
  type        = any
  default     = {}
}

variable "monitoring" {
  description = "Gcp project iam definition more info in submodule  ./monitoring"
  type        = any
  default     = {}
}

variable "logging" {
  description = "Logging settings"
  type        = any
  default     = {}
}

variable "alloydbs" {
  description = "Alloydb clusters"
  type        = any
  default     = {}
}
