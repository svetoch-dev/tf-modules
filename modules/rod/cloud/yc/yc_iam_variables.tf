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
      k8s-nodes = {
        description = "default service account for k8s nodes"
      }
      external-dns = {
        description = "k8s sigs external dns service account"
      },
      thanos = {
        description = "service account for thanos"
      }
      postgres = {
        description = "service account for postgres-operator to store wal-e archiving"
      }
      argocd = var.env.short_name == "int" ? {
        description = "argocd service account"
      } : null
      grafana-loki = {
        description = "service account for loki"
      }
      fluent = {
        description = "service account for fluent"
      }
      runner = var.env.short_name == "int" ? {
        description = "service account for ci runners"
      } : null
      runner-app = var.env.short_name == "int" ? {
        description = "service account for app ci runners"
      } : null
    }

    roles = {
      owners = {
        role = "admin"
        members = concat(
          local.users.owners,
          [
            "serviceAccount:${data.yandex_iam_service_account.sa_int["runner"].id}",
          ]
        )
      }
    }
  }
}

data "yandex_iam_service_account" "sa_int" {
  for_each = {
    "runner-app" = "stub",
    "runner"     = "stub",
  }
  name      = each.key
  folder_id = var.int_env.cloud.folder_id
}
