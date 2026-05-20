locals {
  rbac = {
    service_accounts = merge(
      {
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
        thanos = {
          namespace = "prometheus"
          name      = "thanos"
        }
      },
      {
        for app_name, app_obj in var.env.apps :
        "${app_name}.postgres" => {
          namespace = app_obj.name
          name      = "postgres"
        }
        if app_obj.postgres == true
      }
    )
  }
}
