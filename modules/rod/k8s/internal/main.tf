provider "kubernetes" {
  host                   = var.k8s_api.endpoint
  token                  = var.k8s_api.token
  cluster_ca_certificate = var.k8s_api.ca_cert
}

module "internal" {
  source  = "../../k8s"
  k8s_api = local.k8s_api
  ci      = var.ci
  int_env = var.int_env
  env     = var.env
  overrides = {
    rbac       = local.rbac_merged
    namespaces = local.namespaces_merged
  }
}
