variable "folder_id" {
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
      name   = string
      create = optional(bool, true)
    }
  )
}
