locals {
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
    }
  }
}
