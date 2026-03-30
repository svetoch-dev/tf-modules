variable "folder_id" {
  description = "Yandex Cloud folder id"
  type        = string
}

variable "name" {
  description = "Service account name"
  type        = string
}

variable "description" {
  description = "Service account description"
  type        = string
}

variable "roles" {
  description = "Service account roles"
  type        = list(string)
  default     = []
}

variable "sa_iam_bindings" {
  description = "Service account IAM bindings"
  type = map(
    list(string)
  )
  default = {}
}

variable "generate_key" {
  description = "Generate key or not for this service account"
  type        = bool
  default     = false
}
