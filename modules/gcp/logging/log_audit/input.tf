variable "project_id" {
  description = "Gcp project id"
  type        = string
}

variable "service" {
  description = "Audit service name"
  type        = string
}

variable "configs" {
  description = "Audit configs for the service"
  type = list(object(
    {
      type = string
      exempted_members = optional(
        list(string)
      )
    }
  ))
}
