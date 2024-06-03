variable "name" {
  description = "Api token name"
  type        = string
}

variable "not_before" {
  description = "The time before which the token MUST NOT be accepted for processing."
  type        = string
  default     = null
}

variable "expires_on" {
  description = "The expiration time on or after which the token MUST NOT be accepted for processing."
  type        = string
  default     = null
}

variable "policies" {
  description = "Token policies"
  type = map(
    object(
      {
        permission_groups = list(string)
        resources         = map(string)
        effect            = optional(string, "allow")
      }
    )
  )
}
