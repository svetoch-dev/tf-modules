module "gcp_client_config" {
  for_each = var.env.cloud.name == "gcp" ? {
    "this" = ""
  } : {}
  source = "../../gcp/client_config"
}

module "yc_client_config" {
  for_each = var.env.cloud.name == "yc" ? {
    "this" = ""
  } : {}
  source = "../../yc/client_config"
}

module "k8s" {
  source = "../../k8s"
  k8s_api = merge(
    var.k8s_api,
    {
      token = lookup(
        {
          gcp = module.gcp_client_config["this"].this.access_token
          yc  = module.yc_client_config["this"].this.iam_token
        },
        var.env.cloud.name
      )
    }
  )
  rbac       = local.rbac_merged
  namespaces = local.namespaces_merged
}
