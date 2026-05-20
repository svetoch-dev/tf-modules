variable "service_accounts" {
  type = map(
    object(
      {
        secret = optional(
          map(
            object(
              {
                name = string
              }
            )
          ),
          {}
        )
        automount_service_account_token = optional(bool, true)
        annotations                     = optional(map(string), {})
        namespace                       = string
        name                            = string
      }
    )
  )
  default = {}
}

variable "cluster_roles" {
  type = map(
    object(
      {
        labels      = optional(map(string), {})
        annotations = optional(map(string), {})
        rule = optional(
          map(
            object(
              {
                api_groups        = optional(list(string), [])
                resources         = optional(list(string), [])
                resource_names    = optional(list(string), [])
                verbs             = list(string)
                non_resource_urls = optional(list(string), [])
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

variable "cluster_role_binding" {
  type = map(
    object(
      {
        labels      = optional(map(string), {})
        annotations = optional(map(string), {})
        role_ref = object(
          {
            kind = string
            name = string
          }
        )
        subject = optional(
          map(
            object(
              {
                api_group = optional(string)
                kind      = string
                name      = string
                namespace = optional(string)
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

variable "roles" {
  type = map(
    object(
      {
        labels      = optional(map(string), {})
        annotations = optional(map(string), {})
        namespace   = string
        rule = optional(
          map(
            object(
              {
                api_groups     = optional(list(string), [])
                resources      = optional(list(string), [])
                resource_names = optional(list(string), [])
                verbs          = list(string)
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

variable "role_binding" {
  type = map(
    object(
      {
        labels      = optional(map(string), {})
        annotations = optional(map(string), {})
        namespace   = string
        role_ref = object(
          {
            kind = string
            name = string
          }
        )
        subject = optional(
          map(
            object(
              {
                api_group = optional(string)
                kind      = string
                name      = string
                namespace = optional(string)
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
