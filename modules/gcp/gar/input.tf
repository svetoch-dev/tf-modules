variable "project_id" {
  type = string
}

variable "pullers" {
  type    = list(any)
  default = []
}

variable "pushers" {
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
        description   = optional(string, "")
        format        = optional(string, "DOCKER")
        mode          = optional(string, "STANDARD_REPOSITORY")
        upstream_repo = optional(string)
        priority      = optional(number, 10)
      }
    )
  )
}
