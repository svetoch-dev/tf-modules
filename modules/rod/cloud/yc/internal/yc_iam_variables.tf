locals {
  users = {
    owners = [
      for user_name, user_obj in var.env.users :
      "userAccountName:${user_obj.name}"
      if contains(user_obj.roles, "owner")
    ]
  }
  yc_iam = {
    service_accounts = {
      argocd = {
        name        = "argocd-${var.env.short_name}"
        description = "argocd service account"
        federated_credentials = var.env.initial_start == true ? {} : {
          main = {
            federation_id       = "k8s_federation_id"
            external_subject_id = "system:serviceaccount:argocd:argocd"
          }
        }
      }
      runner = {
        name = "runner-${var.env.short_name}"
        roles = [
          "admin"
        ]
        description = "service account for ci runners"
        federated_credentials = var.env.initial_start == true ? {} : {
          main = {
            federation_id       = "k8s_federation_id"
            external_subject_id = "system:serviceaccount:${var.ci.type}-runner:runner"
          }
        }
      }
      runner-app = {
        name        = "runner-app-${var.env.short_name}"
        description = "service account for app ci runners"
        federated_credentials = var.env.initial_start == true ? {} : {
          main = {
            federation_id       = "k8s_federation_id"
            external_subject_id = "system:serviceaccount:${var.ci.type}-runner-app:runner-app"
          }
        }
      }
    }

    roles = {
      owners = {
        role = "admin"
        members = concat(
          local.users.owners,
        )
      }
    }
  }
}
