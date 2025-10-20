variable "name" {
  description = "Repository name"
  type        = string
}

variable "deploy_keys" {
  description = "Repository deploy keys"
  type = map(
    object(
      {
        name      = string
        key       = string
        read_only = bool
      }
    )
  )
  default = {}
}

variable "secrets" {
  description = "Repository secrets"
  type = map(
    object(
      {
        name       = string
        text_value = string
      }
    )
  )
  default = {}
}

variable "vars" {
  description = "Repository variables"
  type = map(
    object(
      {
        name  = string
        value = string
      }
    )
  )
  default = {}
}
