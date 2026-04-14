variable "name" {
  description = "The name of the OIDC workload identity federation."
  type        = string
}

variable "issuer" {
  description = "The OIDC issuer URL used to validate the incoming token."
  type        = string
}

variable "jwks_url" {
  description = "The URL used to fetch the OIDC provider JSON Web Key Set."
  type        = string
}

variable "folder_id" {
  description = "The ID of the folder where the federation will be created."
  type        = string
  default     = null
}

variable "audiences" {
  description = "Allowed audience values for incoming OIDC tokens."
  type        = list(string)
}

variable "description" {
  description = "An optional description of this federation."
  type        = string
  default     = null
}

variable "disabled" {
  description = "Whether the federation is disabled."
  type        = bool
  default     = false
}

variable "labels" {
  description = "A set of key/value label pairs assigned to the federation."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Custom timeouts for the OIDC federation resource."
  type = object(
    {
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }
  )
  default = null
}
