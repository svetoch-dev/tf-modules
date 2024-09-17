variable "name" {
  description = "vm name"
  type        = string
}

variable "project_id" {
  description = "gcp project id"
  type        = string
}

variable "machine_type" {
  description = "vm machine type https://cloud.google.com/compute/docs/machine-resource"
  type        = string
}

variable "disk" {
  description = "vm disk definition"
  type = object(
    {
      size_gb = number,
      type    = string
    }
  )
  default = {
    size_gb = 10,
    type    = "pd-balanced",
  }
}

variable "network_config" {
  description = "Network config of the vm"
  type = object(
    {
      subnet = string
      public_ip = optional(
        object(
          {
            static = optional(
              object(
                {
                  name        = string
                  description = optional(string, "")
                }
              ),
            )
            ephemeral = optional(bool, false)
            #One of PREMIUM, STANDARD or FIXED_STANDARD.
            network_tier = optional(string, "STANDARD")
          }
        )
      )
    }
  )
}

variable "zone" {
  description = "zone where the vm should run"
  type        = string
}

variable "image" {
  description = "vm image definition"
  type = object(
    {
      name    = optional(string, "")
      project = optional(string)
      family  = optional(string)
    }
  )
}

variable "metadata" {
  description = "vm metadata"
  type        = map(string)
  default     = {}
}

variable "service_account" {
  description = "Service account definition"
  type = object(
    {
      name = optional(string),
      scopes = optional(
        list(string),
        []
      ),
      email       = optional(string),
      description = optional(string, "")
      roles = optional(
        list(string),
        []
      )
      sa_iam_bindings = optional(
        map(
          list(string)
        ),
        {}
      )
    }
  )
}

variable "tags" {
  description = "vm tags"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "vm lables"
  type        = map(string)
  default     = {}
}

variable "iam_roles" {
  description = "Iam roles for the vm"
  type = list(
    object(
      {
        role    = string
        members = list(string)
      }
    )
  )
  default = []
}

variable "additional_disks" {
  description = "Additional persistant disks to attach to vm"
  type = list(
    object(
      {
        name        = string
        size        = number
        type        = string
        auto_delete = optional(bool, false)
      }
    )
  )
  default = []
}
