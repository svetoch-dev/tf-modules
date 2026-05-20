locals {
  namespaces = merge(
    {
      cert-manager = {
        name = "cert-manager"
      }
      external-dns = {
        name = "external-dns"
      }
      fluent = {
        name = "fluent"
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
    },
    {
      for app_name, app_obj in var.env.apps :
      app_name => {
        name = app_obj.name
      }
    }
  )
}
