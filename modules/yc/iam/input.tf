variable "service_accounts" {
  type = map(
    object(
      {
        description = string
        roles       = optional(list(string), [])
        sa_iam_bindings = optional(
          map(
            list(string)
          ),
          {}
        )
        generate_key = optional(bool, false)
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
