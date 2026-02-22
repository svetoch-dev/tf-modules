locals {
  namespaces = merge(
    {
      argocd = var.env.short_name == "int" ? {
        name = "argocd"
      } : null
      cert-manager = {
        name = "cert-manager"
      }
      external-dns = {
        name = "external-dns"
      }
      fluent = {
        name = "fluent"
      }
      grafana = var.env.short_name == "int" ? {
        name = "grafana"
      } : null
      konghq = {
        name = "konghq"
      }
      loki = {
        name = "loki"
      }
      pomerium = {
        name = "pomerium"
      }
      prometheus = {
        name = "prometheus"
      }
      postgres = {
        name = "postgres"
      }
      rabbitmq = {
        name = "rabbitmq"
      }
      redis = {
        name = "redis"
      }
      "${var.ci.type}-runner" = var.env.short_name == "int" ? {
        name = "${var.ci.type}-runner"
      } : null
      "${var.ci.type}-runner-app" = var.env.short_name == "int" ? {
        name = "${var.ci.type}-runner-app"
      } : null
    },
    var.ci.type == "gha" && var.env.short_name == "int" ? {
      gha-operator = {
        name = "gha-operator"
      }
    } : {},
    {
      for app_name, app_obj in var.apps :
      app_name => {
        name = app_obj.name
      }
    }
  )
}
