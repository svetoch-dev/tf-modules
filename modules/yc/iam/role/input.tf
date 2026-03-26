variable "folder_id" {
  description = "Yandex Cloud folder id"
  type        = string
}

variable "role" {
  description = "IAM role"
  type        = string
}

variable "members" {
  description = "Members of specified role"
  type        = list(string)
}
