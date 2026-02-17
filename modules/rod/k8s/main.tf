#data "yandex_client_config" "client" {}
module "gcp_client_config" {
  for_each = var.env.cloud.name == "gcp" ? {
    "this" = ""
  } : {}
}

module "k8s" {
  source = "../../k8s"
  k8s_api = merge(
    var.k8s_api,
    {
      token = lookup(
        {
          gcp = module.gcp_client_config.this.access_token
          #yc  = data.yandex_client_config.client.iam_token
        },
        var.env.cloud.name
      )
    }
  )
  rbac       = local.rbac_merged
  namespaces = local.namespaces_merged
}
