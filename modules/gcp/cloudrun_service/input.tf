variable "name" {
  description = "Cloudrun service name"
  type        = string
}

variable "project_id" {
  description = "Cloudrun service project id"
  type        = string
}

variable "labels" {
  description = "Cloudrun service project id"
  type        = map(string)
}

variable "location" {
  description = "Cloudrun service location"
  type        = string
}

variable "execution_environment" {
  description = "Cloudrun execution environment EXECUTION_ENVIRONMENT_GEN2|EXECUTION_ENVIRONMENT_GEN1"
  type        = string
  default     = "EXECUTION_ENVIRONMENT_GEN2"
}

variable "max_instance_requests" {
  description = "Sets the maximum number of requests that each serving instance can receive."
  type        = number
  default     = 80
}

variable "ingress" {
  description = "cloudrun service ingress policy"
  type        = string
  default     = "INGRESS_TRAFFIC_ALL"
}

variable "service_account" {
  description = "cloudrun service google service account"
  type        = string
}

variable "neg_enabled" {
  description = "enable neg for cloudrun service"
  type        = bool
  default     = false
}

variable "volumes" {
  description = "volumes definition"
  type = map(
    object(
      {
        name = string
        secret = object(
          {
            secret = string
            items = object(
              {
                version = string
                path    = string
              }
            )
          }
        )
      }
    )
  )

  default = {}
}

variable "container" {
  description = "Cloudrun container definition"
  type = object(
    {
      image = string
      volume_mounts = optional(
        map(
          object(
            {
              name = string
              path = string
            }
          )
        )
      )
      ports = list(
        object(
          {
            name           = optional(string)
            container_port = number
          }
        )
      )
      env = optional(
        list(
          object(
            {
              name  = string
              value = optional(string)
              secret_key_ref = optional(
                object(
                  {
                    secret  = string
                    version = string
                  }
                )
              )
            }
          )
        ),
        []
      )
      resources = object(
        {
          limits = object(
            {
              memory = string
              cpu    = string
            }
          )
          cpu_idle          = optional(bool, true)
          startup_cpu_boost = optional(bool, false)
        }
      )
    }
  )
}

variable "scaling" {
  description = "cloudrun service scaling options"
  type = object(
    {
      min_instance_count = number
      max_instance_count = number
    }
  )
}

variable "vpc_access" {
  description = "cloudrun service vpc access configuration"
  type = object(
    {
      connector = string
      egress    = string
    }
  )
  default = null
}

variable "members" {
  type        = list(string)
  description = "Users/SAs to be given invoker access to the service"
  default = [
    "allUsers"
  ]
}

variable "domains" {
  type = map(
    object(
      {
        name = string
      }
    )
  )
  default = {}
}
