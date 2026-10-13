variable "service_accounts" {
  type = map(
    object(
      {
        description        = string
        name               = optional(string)
        roles              = optional(list(string), [])
        cloud_roles        = optional(list(string), [])
        organization_roles = optional(list(string), [])
        sa_iam_bindings = optional(
          map(
            list(string)
          ),
          {}
        )
        generate_key = optional(bool, false)
        federated_credentials = optional(
          map(
            object(
              {
                federation_id       = string
                external_subject_id = string
              }
            )
          ),
          {}
        )
      }
    )
  )
  default = {}
}

variable "oidc_federations" {
  type = map(
    object(
      {
        issuer      = string
        jwks_url    = string
        audiences   = list(string)
        description = optional(string)
        disabled    = optional(bool, false)
        labels      = optional(map(string), {})
        timeouts = optional(
          object(
            {
              create = optional(string)
              update = optional(string)
              delete = optional(string)
            }
          )
        )
      }
    )
  )
  default = {}
}

variable "roles" {
  type = map(
    object(
      {
        role    = string
        members = list(string)
      }
    )
  )
  default = {}
}

variable "folder_id" {
  type = string
}

variable "cloud_id" {
  description = "Yandex Cloud ID for service account cloud roles"
  type        = string
  default     = null
}

variable "organization_id" {
  description = "Yandex Cloud organization ID for service account organization roles"
  type        = string
  default     = null
}
