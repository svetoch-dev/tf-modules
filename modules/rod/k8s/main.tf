data "google_client_config" "client" {}

data "yandex_client_config" "client" {}


module "k8s" {
  source = "../../k8s"
  k8s_api = merge(
    var.k8s_api,
    {
      token = lookup(
        {
          gcp = data.google_client_config.client.access_token
          yc  = data.yandex_client_config.client.iam_token
        },
        var.env.cloud
      )
    }
  )
  rbac       = local.rbac
  namespaces = local.namespaces
}
