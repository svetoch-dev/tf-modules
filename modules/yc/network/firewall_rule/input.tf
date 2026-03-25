variable "name" {
  description = "Firewall rule name."
  type        = string
}

variable "folder_id" {
  description = "The folder where the security group will be created."
  type        = string
}

variable "network_id" {
  description = "The network where the security group will be created."
  type        = string
}

variable "rule" {
  description = "firewall rule for Yandex Cloud."
  type = object(
    {
      direction     = string
      source_ranges = optional(list(string), [])
      description   = optional(string, null)
      allow = optional(
        map(
          object(
            {
              ports = optional(list(string), [])
            }
          )
        ),
        {}
      )
    }
  )
}
