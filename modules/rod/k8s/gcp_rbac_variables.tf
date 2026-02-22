locals {
  rbac_gcp = {
    service_accounts = {
      for service_account_name, service_account_obj in local.rbac_main.service_accounts :
      service_account_name => merge(
        service_account_obj,
        {
          annotations = {
            "iam.gke.io/gcp-service-account" = "${service_account_obj.name}@${var.env.cloud.id}.iam.gserviceaccount.com"
          }
        }
      )
      if service_account_obj != null
    }
    cluster_role_binding = {
      argocd = var.env.short_name == "int" ? null : {
        subject = {
          argocd = {
            name = "argocd@${var.int_env.cloud.id}.iam.gserviceaccount.com"
          }
        }
      }
    }
  }
}
