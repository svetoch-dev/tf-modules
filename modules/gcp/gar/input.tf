variable "registries" {
  description = "Google artifact registry repositories"
  type = map(
    object(
      {
        location    = string
        description = optional(string, "")
        format      = optional(string, "DOCKER")
        mode        = optional(string, "STANDARD_REPOSITORY")
        readers     = list(any)
        writers     = list(any)
        upstream_repositories = optional(map(object({
          priority = optional(number, 10)
        })), null)
        remote_repository = optional(object({
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
        }), null)
      }
    )
  )
}
