variable "cloud_id" {
  type    = string
  default = null
}
variable "folder_id" {
  type    = string
  default = null
}
variable "zone" {
  type    = string
  default = null
}
variable "sa_key_file" {
  type    = string
  default = null
}

providers "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone

  service_account_key_file = var.sa_key_file
}

data "yandex_client_config" "client" {}
