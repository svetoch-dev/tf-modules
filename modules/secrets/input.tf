variable "name" {
  type        = string
  description = "Secret name"
}

variable "secrets_to_import" {
  type        = list(string)
  description = "Secrets that needed to be imported in state"
  default     = []
}

variable "secrets_data" {
  type        = map(string)
  description = "Secrets that needed to be created from output of tf resources"
  default     = {}
}

variable "base64_secrets" {
  type        = bool
  description = "Are secrets base64 encoded strings"
  default     = false
}

variable "annotations" {
  type        = map(string)
  description = "Secret annotations"
  default     = {}
}

variable "labels" {
  type        = map(string)
  description = "Secret labels"
  default     = {}
}

variable "gcp" {
  type = object(
    {
      enabled = bool
      iam_roles = optional(
        list(
          object(
            {
              role    = string
              members = list(string)
            }
          )
        )
      )
      kms_key = optional(string)
    }
  )
  description = "Gcp secret definition"
  default = {
    enabled   = false
    iam_roles = []
    kms_key   = null
  }

}

variable "k8s" {
  type = object(
    {
      enabled   = bool
      namespace = string
    }
  )
  description = "k8s secret definition"
  default = {
    enabled   = false
    namespace = "default"
  }

}

