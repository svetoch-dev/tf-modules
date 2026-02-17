locals {
  namespaces = merge(
    {
      argocd = {
        name = "argocd"
      }
      cert-manager = {
        name = "cert-manager"
      }
      external-dns = {
        name = "external-dns"
      }
      fluent = {
        name = "fluent"
      }
      grafana = {
        name = "grafana"
      }
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
      "${var.ci.type}-runner" = {
        name = "${var.ci.type}-runner"
      }
      "${var.ci.type}-runner-app" = {
        name = "${var.ci.type}-runner-app"
      }
    },
    var.ci.type != "gha" ? {} : {
      gha-operator = {
        name = "gha-operator"
      }
    },
    {
      for app_name, app_obj in var.apps :
      app_name => {
        name = app_obj.name
      }
    }
  )
}
