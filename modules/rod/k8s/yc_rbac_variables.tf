locals {
  rbac_yc = {
    service_accounts = {
      vedro = {
        annotations = {
          "yandex.cloud/federated-yc-service-account-id" = var.env.cloud.name == "yc" ? var.cloud_service_accounts["vedro"].id : null
        }
      }
    }
  }
}
