variable "cloud_id" { type = optional(string) }
variable "folder_id" { type = optional(string) }
variable "zone" { type = optional(string) }
variable "sa_key_file" { type = optional(string) }

providers "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone

  service_account_key_file = var.sa_key_file
}

data "yandex_client_config" "client" {}
