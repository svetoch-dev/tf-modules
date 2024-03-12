variable "repository_id" {
  description = "Google artifact registry repository name"
  type        = string
}

variable "location" {
  description = "The name of the location this repository is located in"
  type        = string
}

variable "description" {
  description = "The user-provided description of the repository"
  type        = string
  default     = ""
}

variable "format" {
  description = "The format of packages that are stored in the repository"
  type        = string
  default     = "DOCKER"
}

variable "mode" {
  description = "The mode configures the repository to serve artifacts from different sources. Possible values are: STANDARD_REPOSITORY, VIRTUAL_REPOSITORY, REMOTE_REPOSITORY"
  type        = string
  default     = "STANDARD_REPOSITORY"
}

variable "readers" {
  description = "The list of users who have the right to read"
  type        = list(any)
  default     = []
}

variable "writers" {
  description = "The list of users who have the right to write"
  type        = list(any)
  default     = []
}

variable "virtual_repository" {
  description = "Configuration specific for a Virtual Repository"
  type = object({
    upstream_repositories = map(object({
      repository = optional(string)
      priority   = optional(number, 10)
    }))
  })
  default = null
}

variable "remote_repository" {
  description = "Configuration specific for a Remote Repository"
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
