variable "project_id" {
  type = string
}

variable "readers" {
  type    = list(any)
  default = []
}

variable "writers" {
  type    = list(any)
  default = []
}

variable "location" {
  description = "Location(region) of gar repositories"
  type        = string
}

variable "registries" {
  description = "Google artifact registry repositories"
  type = map(
    object(
      {
        description = optional(string, "")
        format      = optional(string, "DOCKER")
        mode        = optional(string, "STANDARD_REPOSITORY")
        upstream_repositories = optional(
          map(
            object(
              {
                priority = optional(number, 10)
              }
            )
          )
        )
        remote_repository = optional(
          object(
            {
              description = optional(string,"")
              docker_repository = optional(
                object(
                  {
                    public_repository = optional(string, "DOCKER_HUB")
                  }
                ), null
              )
              apt_repository = optional(
                object(
                  {
                    repository_base = string
                    repository_path = string
                  }
                ), null
              )
              yum_repository = optional(
                object(
                  {
                    repository_base = string
                    repository_path = string
                  }
                ), null
              )
            }
          )
        )
      }
    )
  )
}
