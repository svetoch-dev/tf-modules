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
      external-dns = {
        name        = "external-dns-${var.env.short_name}"
        description = "k8s sigs external dns service account"
        roles = [
          "dns.admin"
        ]
        federated_credentials = var.env.initial_start == true ? {} : {
          main = {
            federation_id       = module.yc.k8s_clusters[var.env.short_name].federation.id
            external_subject_id = "system:serviceaccount:external-dns:external-dns"
          }
        }
      },
      thanos = {
        name        = "thanos-${var.env.short_name}"
        description = "service account for thanos"
        federated_credentials = var.env.initial_start == true ? {} : {
          main = {
            federation_id       = module.yc.k8s_clusters[var.env.short_name].federation.id
            external_subject_id = "system:serviceaccount:prometheus:thanos"
          }
        }
      }
      postgres = {
        name        = "postgres-${var.env.short_name}"
        description = "service account for postgres-operator to store wal-e archiving"
        federated_credentials = var.env.initial_start == true ? {} : merge(
          {
            main = {
              federation_id       = module.yc.k8s_clusters[var.env.short_name].federation.id
              external_subject_id = "system:serviceaccount:postgres:postgres"
            }
          },
          {
            for app_name, app_obj in var.env.apps :
            tostring(app_name) => {
              federation_id       = module.yc.k8s_clusters[var.env.short_name].federation.id
              external_subject_id = "system:serviceaccount:${app_obj.name}:postgres"
            }
          }
        )
      }
      argocd = var.env.short_name == "int" ? {
        name        = "argocd-${var.env.short_name}"
        description = "argocd service account"
        federated_credentials = var.env.initial_start == true ? {} : {
          main = {
            federation_id       = module.yc.k8s_clusters[var.env.short_name].federation.id
            external_subject_id = "system:serviceaccount:argocd:argocd"
          }
        }
      } : null
      grafana-loki = {
        name        = "grafana-loki-${var.env.short_name}"
        description = "service account for loki"
        federated_credentials = var.env.initial_start == true ? {} : {
          main = {
            federation_id       = module.yc.k8s_clusters[var.env.short_name].federation.id
            external_subject_id = "system:serviceaccount:loki:grafana-loki"
          }
        }
      }
      fluent = {
        name        = "fluent-${var.env.short_name}"
        description = "service account for fluent"
        federated_credentials = var.env.initial_start == true ? {} : {
          main = {
            federation_id       = module.yc.k8s_clusters[var.env.short_name].federation.id
            external_subject_id = "system:serviceaccount:fluent:fluent"
          }
        }
      }
      runner = var.env.short_name == "int" ? {
        name = "runner-${var.env.short_name}"
        roles = [
          "admin"
        ]
        description = "service account for ci runners"
        federated_credentials = var.env.initial_start == true ? {} : {
          main = {
            federation_id       = module.yc.k8s_clusters[var.env.short_name].federation.id
            external_subject_id = "system:serviceaccount:${var.ci.type}-runner:runner"
          }
        }
      } : null
      runner-app = var.env.short_name == "int" ? {
        name        = "runner-app-${var.env.short_name}"
        description = "service account for app ci runners"
        federated_credentials = var.env.initial_start == true ? {} : {
          main = {
            federation_id       = module.yc.k8s_clusters[var.env.short_name].federation.id
            external_subject_id = "system:serviceaccount:${var.ci.type}-runner-app:runner-app"
          }
        }
      } : null
    }

    roles = {
      owners = {
        role = "admin"
        members = concat(
          local.users.owners,
          var.env.short_name != "int" ? [
            "serviceAccountName:${var.int_env.cloud.folder_id}:runner-${var.int_env.short_name}"
          ] : []
        )
      }
    }
  }
}
