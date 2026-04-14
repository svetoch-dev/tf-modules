variable "folder_id" {
  type = string
}

variable "name" {
  type = string
}

variable "pullers" {
  type    = list(string)
  default = []
}

variable "pushers" {
  type    = list(string)
  default = []
}

variable "registry" {
  type = object(
    {
      create = optional(bool, true)
    }
  )
}
