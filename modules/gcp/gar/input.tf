variable "repository_id" {
  description = "Google artifact registry repository name"
  type        = string
}

variable "location" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "format" {
  type    = string
  default = "DOCKER"
}

variable "mode" {
  type    = string
  default = "STANDARD_REPOSITORY"
}

variable "readers" {
  type    = list(any)
  default = []
}

variable "writers" {
  type    = list(any)
  default = []
}

variable "virtual_repository" {
  type = object({
    upstream_repositories = map(object({
      repository = optional(string)
      priority   = optional(number, 10)
    }))
  })
  default = null
}

variable "remote_repository" {
  type = object({
    description = optional(string, "")
    docker_repository = optional(object({
      public_repository = optional(string, "DOCKER_HUB")
    }), null)
    apt_repository = optional(object({
      repository_base = string
      repository_path = string
    }), null)
    yum_repository = optional(object({
      repository_base = string
      repository_path = string
    }), null)
  })
  default = null
}
