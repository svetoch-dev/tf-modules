locals {
  rbac_gcp = {
    service_accounts = {
      for service_account_name, service_account_obj in local.rbac.service_accounts :
      service_account_name => merge(
        service_account_obj,
        {
          annotations = {
            "iam.gke.io/gcp-service-account" = "${service_account_name}@${local.env.cloud.id}.iam.gserviceaccount.com"
          }
        }
      )
    }
  }
}
