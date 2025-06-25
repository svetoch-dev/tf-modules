variable "name" {
  description = "cloudrun job name"
  type        = string
}

variable "project_id" {
  description = "cloudrun job project id"
  type        = string
}

variable "labels" {
  description = "cloudrun job project id"
  type        = map(string)
}

variable "location" {
  description = "cloudrun job location"
  type        = string
}

variable "execution_environment" {
  description = "Cloudrun execution environment EXECUTION_ENVIRONMENT_GEN2|EXECUTION_ENVIRONMENT_GEN1"
  type        = string
  default     = "EXECUTION_ENVIRONMENT_GEN2"
}

variable "service_account" {
  description = "cloudrun job google service account"
  type        = string
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

variable "containers" {
  description = "Cloudrun containers definition"
  type = map(
    object(
      {
        image   = string
        command = optional(list(string))
        args    = optional(list(string))
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
          }
        )
      }
    )
  )
}

variable "vpc_access" {
  description = "cloudrun job vpc access configuration"
  type = object(
    {
      connector = string
      egress    = string
    }
  )
  default = null
}

variable "parallelism" {
  description = "cloudrun job parallelism"
  type        = number
  default     = 1
}

variable "timeout" {
  description = "cloudrun job timeout"
  type        = string
  default     = null
}

variable "max_retries" {
  description = "cloudrun job retries"
  type        = number
  default     = 3
}
