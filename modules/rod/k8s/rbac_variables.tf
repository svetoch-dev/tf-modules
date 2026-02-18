locals {
  rbac_main = {
    service_accounts = merge(
      {
        argocd = var.env.short_name == "int" ? {
          namespace = "argocd"
          name      = "argocd"
        } : null
        external-dns = {
          namespace = "external-dns"
          name      = "external-dns"
        }
        fluent = {
          namespace = "fluent"
          name      = "fluent"
        }
        grafana-loki = {
          namespace = "loki"
          name      = "grafana-loki"
        }
        "postgres.postgres" = {
          name      = "postgres"
          namespace = "postgres"
        }
        runner = var.env.short_name == "int" ? {
          namespace = "${var.ci.type}-runner"
          name      = "runner"
        } : null
        runner-app = var.env.short_name == "int" ? {
          namespace = "${var.ci.type}-runner-app"
          name      = "runner-app"
        } : null
        thanos = {
          namespace = "prometheus"
          name      = "thanos"
        }
      },
      {
        for app_name, app_obj in var.apps :
        "${app_name}.postgres" => {
          namespace = app_obj.name
          name      = "postgres"
        }
      }
    )
    cluster_roles = {
    }
    cluster_role_binding = {
      argocd = var.env.short_name == "int" ? null : {
        labels      = {},
        annotations = {},
        role_ref = {
          kind = "ClusterRole"
          name = "cluster-admin"
        }
        subject = {
          argocd = {
            api_group = "rbac.authorization.k8s.io"
            kind      = "User"
            #This is overriden in per cloud rbac versions
            name      = ""
            namespace = ""
          }
        }
      }
    }
    roles        = {}
    role_binding = {}
  }
}
