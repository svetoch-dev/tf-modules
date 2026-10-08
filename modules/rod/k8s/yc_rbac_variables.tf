locals {
  rbac_yc = {
    service_accounts = {
      for service_account_name, service_account_obj in local.rbac_processed.service_accounts :
      service_account_name => merge(
        service_account_obj,
        lookup(var.cloud_service_accounts, service_account_name, null) == null ? {} : {
          annotations = {
            "yandex.cloud/federated-yc-service-account-id" = var.cloud_service_accounts[service_account_name].id
          }
        }
      )
      if service_account_obj != null
    }
  }
}
