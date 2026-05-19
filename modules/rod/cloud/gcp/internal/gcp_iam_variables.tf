locals {
  gcp_iam = {
    service_accounts = {
      argocd = {
        description = "argocd service account"
        roles = [
        ]
        custom_roles = []
        sa_iam_bindings = var.env.initial_start ? {} : {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.env.cloud.id}.svc.id.goog[argocd/argocd]",
          ]
        }
        generate_key = false
      }
      runner = {
        description = "service account for ci runners"
        roles = [
          "roles/owner"
        ]
        custom_roles = []
        sa_iam_bindings = var.env.initial_start || var.ci == null ? {} : {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.env.cloud.id}.svc.id.goog[${var.ci.type}-runner/runner]"
          ]
        }
        generate_key = false
      }
      runner-app = {
        description  = "service account for app ci runners"
        roles        = []
        custom_roles = []
        sa_iam_bindings = var.env.initial_start || var.ci == null ? {} : {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.env.cloud.id}.svc.id.goog[${var.ci.type}-runner-app/runner-app]"
          ]
        }
        generate_key = false
      }
    }

    roles = {
      owners = {
        role = "roles/owner"
        members = concat(
          [
            for user_name, user_obj in var.env.users :
            "user:${user_obj.name}"
            if contains(user_obj.roles, "owner")
          ],
        )
      }
      devs = {
        role = "projects/${var.env.cloud.id}/roles/developers"
        members = [
          for user_name, user_obj in var.env.users :
          "user:${user_obj.name}"
          if contains(user_obj.roles, "dev")
        ]
      }
    }
  }
}
